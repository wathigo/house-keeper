class Helpers
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def get_dependabot_prs(prs)
    prs.map { |pr| pr if dependabot_pr?(pr) }
  end

  def dependabot_pr?(pr)
    pr['user']['login'] == 'dependabot[bot]'
  end

  def opened?
    @payload['action'] == 'opened'
  end

  def created?
    @payload['action'] == 'created'
  end

  def added?
    @payload['action'] == 'added'
  end
end
