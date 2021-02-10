require 'sinatra'
require 'octokit'
require 'dotenv/load'
require 'json'
require 'openssl'
require 'jwt'
require 'time'
require 'logger'

require_relative 'lib/helpers'

set :port, 3000
set :bind, '0.0.0.0'

class GHAapp < Sinatra::Application
  PRIVATE_KEY = OpenSSL::PKey::RSA.new(ENV['GITHUB_PRIVATE_KEY'].gsub('\n', "\n"))

  WEBHOOK_SECRET = ENV['GITHUB_WEBHOOK_SECRET']

  APP_IDENTIFIER = ENV['GITHUB_APP_IDENTIFIER']

  configure :development do
    set :logging, Logger::DEBUG
  end

  before '/event_handler' do
    get_payload_request(request)
    verify_webhook_signature
    authenticate_app

    authenticate_installation(@payload)
  end

  post '/event_handler' do
    case request.env['HTTP_X_GITHUB_EVENT']
    when 'installation'
      handle_installation_created_event(@payload['repositories']) if @helper.created?

    when 'installation_repositories'
      handle_installation_created_event(@payload['repositories_added']) if @helper.added?

    when 'pull_request'
      full_name = @payload['pull_request']['head']['repo']['full_name']
      pr = @payload['pull_request']
      merge_pr(full_name, user, @payload['number']) if @helper.opened? && @helper.dependabot_pr?(pr)
    end

    200
  end

  helpers do
    def handle_installation_created_event(repos)
      repos.each do |repo|
        logger.debug repo
        all_prs = @installation_client.pull_requests(repo['full_name'], state: 'opened')
        logger.debug(all_prs)
        opened_dependabot_prs = @helper.get_dependabot_prs(all_prs)
        merge_prs(opened_dependabot_prs, repo['full_name'])
      end
    end

    def merge_pr(full_name, user, number)
      comment = 'Thank you @' + user + ' for the update. I am a bot too :)'
      @installation_client.create_pull_request_review(full_name, number, event: 'COMMENT', body: comment)
      @installation_client.merge_pull_request(full_name, number, 'merges dependabot changes')
    end

    def merge_prs(prs, repo)
      prs.each do |pr|
        merge_pr(repo, pr[:user]['login'], pr[:number])
      end
    end

    def get_payload_request(request)
      request.body.rewind

      @payload_raw = request.body.read
      begin
        @payload = JSON.parse @payload_raw
        @helper = Helpers.new(@payload)
      rescue StandardError => e
        raise "Invalid JSON (#{e}): #{@payload_raw}"
      end
    end

    def authenticate_app
      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (10 * 60),
        iss: APP_IDENTIFIER
      }

      jwt = JWT.encode(payload, PRIVATE_KEY, 'RS256')
      @app_client ||= Octokit::Client.new(bearer_token: jwt)
    end

    def authenticate_installation(payload)
      @installation_id = payload['installation']['id']
      @installation_token = @app_client.create_app_installation_access_token(@installation_id)[:token]
      @installation_client = Octokit::Client.new(bearer_token: @installation_token)
    end

    def verify_webhook_signature
      their_signature_header = request.env['HTTP_X_HUB_SIGNATURE'] || 'sha1='
      method, their_digest = their_signature_header.split('=')
      our_digest = OpenSSL::HMAC.hexdigest(method, WEBHOOK_SECRET, @payload_raw)
      halt 401 unless their_digest == our_digest

      logger.debug "---- received event #{request.env['HTTP_X_GITHUB_EVENT']}"
      logger.debug "----    action #{@payload['action']}" unless @payload['action'].nil?
    end
  end
  run! if __FILE__ == $PROGRAM_NAME
end
