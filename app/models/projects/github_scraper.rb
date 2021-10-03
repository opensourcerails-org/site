# frozen_string_literal: true

module Projects
  class GithubScraper
    def initialize(project)
      @project = project
    end

    private

    def get(url, **options)
      HTTP.follow.get(url, headers: { 'Authorization' => "token #{ENV['GITHUB_TOKEN']}" }, **options)
    end
  end
end
