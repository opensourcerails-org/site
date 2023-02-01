# frozen_string_literal: true

module Projects
  class GithubReadmeScraper < GithubScraper
    attr_reader :content

    def initialize(*)
      super
      @content = nil
    end

    def run
      response = get("https://api.github.com/repos/#{@project.github}/git/trees/#{@project.last_commit}")
      json = JSON.parse(response.to_s)
      readme = find_readme(json)
      if readme
        contents = get(readme['url'])
        json = JSON.parse(contents.to_s)
        @content = Base64.decode64(json['content'])
        return true
      end

      nil
    end

    private

    def find_readme(dir)
      dir['tree'].detect { |tree| tree['path'].downcase == 'readme.md' && tree['type'] == 'blob' }
    end
  end
end
