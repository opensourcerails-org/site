# frozen_string_literal: true

module Projects
  class PackageScraper < GithubScraper
    attr_reader :packages

    def initialize(*)
      super
      @packages = []
    end

    def run
      response = get("https://api.github.com/repos/#{@project.github}/git/trees/#{@project.last_commit}")
      json = JSON.parse(response.to_s)
      gemfile = json['tree'].detect { |tree| tree['path'] == 'package.json' && tree['type'] == 'blob' }
      return false unless gemfile

      gemfile_response = HTTP.get(gemfile['url'], headers: { 'Authorization' => "token #{ENV['GITHUB_TOKEN']}" })
      decoded_package = Base64.decode64(gemfile_response.parsed_response['content'])
      json = JSON.parse(decoded_package)
      @packages = json['dependencies'].keys if json['dependencies']
    end
  end
end
