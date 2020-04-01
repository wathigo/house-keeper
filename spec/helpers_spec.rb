require 'json'
require_relative '../lib/helpers'

RSpec.describe Helpers do
  let (:file1) {File.read('spec/data/pull_requests_none.json')}
  let (:file2) {File.read('spec/data/pull_requests_some.json')}
  let (:file3) {File.read('spec/data/payload1.json')}
  let (:file4) {File.read('spec/data/payload2.json')}
  let (:file5) {File.read('spec/data/payload3.json')}
  let (:file6) {File.read('spec/data/payload4.json')}

  let (:pull_requests_none) {JSON.parse(file1)}
  let (:pull_requests_some) {JSON.parse(file2)}
  let (:closed_action) {Helpers.new(JSON.parse(file3))}
  let (:opened_action) {Helpers.new(JSON.parse(file4))}
  let (:created_action) {Helpers.new(JSON.parse(file5))}
  let (:added_action) {Helpers.new(JSON.parse(file6))}
  let (:helper) {Helpers.new("")}


  describe 'Helpers#get_dependabot_prs' do
    it 'Returns an epmty array if none of the pull requests was created by dependabot' do
      expect(helper.get_dependabot_prs(pull_requests_none)).to eql([nil])
    end

    it 'Returns an array containg all the pull requests created by dependabot' do
      expect(helper.get_dependabot_prs(pull_requests_some)).not_to be_empty
    end
  end

  describe 'Helpers#dependabot_pr?' do
    let (:dependabot_pr) {helper.get_dependabot_prs(pull_requests_some)[0]}
    it 'Returns true if a pull request is created by dependabot' do
      expect(helper.dependabot_pr?(dependabot_pr)).to eql(true)
    end

    it 'Returns false if the creater of the pull request is not dependabot' do
      expect(helper.dependabot_pr?(pull_requests_none[0])).to eql(false)
    end
  end

  describe 'Helpers#opened?' do
    let (:dependabot_pr) {helper.get_dependabot_prs(pull_requests_some)[0]}
    it "Returns true if action in the payload has a value of 'opened'" do
      expect(opened_action.opened?).to eql(true)
    end

    it "Returns false the action value in the payload does not have a value of 'opened'" do
      expect(closed_action.opened?).to eql(false)
    end
  end

  describe 'Helpers#created?' do
    let (:dependabot_pr) {helper.get_dependabot_prs(pull_requests_some)[0]}
    it "Returns true if action in the payload has a value of 'created'" do
      expect(created_action.created?).to eql(true)
    end

    it "Returns false the action value in the payload does not have value of 'created'" do
      expect(closed_action.created?).to eql(false)
    end
  end

  describe 'Helpers#added?' do
    let (:dependabot_pr) {helper.get_dependabot_prs(pull_requests_some)[0]}
    it "Returns true if action in the payload has a value of 'added'" do
      expect(added_action.added?).to eql(true)
    end

    it "Returns false the action value in the payload does not have value of 'added'" do
      expect(created_action.added?).to eql(false)
    end
  end
end
