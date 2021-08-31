# frozen_string_literal: true

module Projects
  class GithubActivityScraper < GithubScraper
    attr_reader :last_activity_at, :last_commit

    def initialize(*)
      super
      @last_activity_at = nil
      @last_commit = nil
    end

    def run
      response = get("https://api.github.com/repos/#{@project.github}/commits")
      json = JSON.parse(response.to_s)
      @last_activity_at = begin
        DateTime.parse(json[0]['commit']['author']['date'])
      rescue StandardError
        10.years.ago
      end
      @last_commit = json[0]['commit']['tree']['sha']
    end
  end
end
