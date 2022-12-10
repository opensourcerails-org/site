# frozen_string_literal: true

module Projects
  class GithubScraper
    def initialize(project)
      @project = project
    end

    private

    def get(url, **options)
      response = HTTP.follow.get(url, headers: { 'Authorization' => "token #{ENV['GITHUB_TOKEN']}" }, **options)
      unless response.code == 200
        raise HTTP::Error, "Got bad response: #{response.code}"
      end
      response
    end
  end
end
