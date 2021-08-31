# frozen_string_literal: true

module Projects
  class GithubMetaScraper < GithubScraper
    attr_reader :branch, :stars, :forks, :about, :watchers, :license, :repo, :name, :website

    def initialize(*)
      super
      @branch = nil
      @stars = nil
      @forks = nil
      @about = nil
      @license = nil
      @repo = nil
      @name = nil
      @website = nil
    end

    def run
      response = get("https://api.github.com/repos/#{@project.github}", follow: true)
      json = JSON.parse(response.to_s)
      @repo = json['full_name']
      @branch = json['default_branch']
      @forks = json['forks_count']
      @stars = json['stargazers_count']
      @watchers = json['subscribers_count'] # yes, subscribers_count.
      @about = json['description']
      @name = json['name']
      @website = json['homepage']
      @license = LicenseFinder.from(json.dig('license', 'name'))
    end
  end
end
