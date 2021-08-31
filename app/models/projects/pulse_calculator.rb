# frozen_string_literal: true

module Projects
  class PulseCalculator < GithubScraper
    SCORES = {
      'WatchEvent' => ->(event) { event['payload']['action'] == 'starred' ? 100 : 10 },
      'ForkEvent' => ->(event) { event['payload']['action'] == 'starred' ? 50 : 25 },
      'IssuesEvent' => ->(event) { event['payload']['action'] == 'opened' ? 75 : 33 },
      'IssueCommentEvent' => ->(event) { event['payload']['action'] == 'opened' ? 225 : 200 }
    }.freeze

    attr_reader :pulse

    def initialize(*)
      super
      @pulse = nil
    end

    def run
      response = get("https://api.github.com/repos/#{@project.github}/events")
      json = JSON.parse(response.to_s)
      score = 0
      json.each do |item|
        result = SCORES[item['type']]
        next if result.nil?

        score += result.call(item)
      end
      @pulse = score
    end
  end
end
