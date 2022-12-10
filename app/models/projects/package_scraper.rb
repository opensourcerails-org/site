# frozen_string_literal: true

module Projects
  class PackageScraper < GithubScraper
    attr_reader :packages

    def initialize(*)
      super
      @packages = []
    end

    def run
      parts = if @project.packages_path.present?
                @project.packages_path.split('/')
              else
                ['package.json']
              end

      content_item = nil
      next_url = "https://api.github.com/repos/#{@project.github}/git/trees/#{@project.last_commit}"
      parts.each_with_index do |part, index|
        response = get(next_url)
        json = JSON.parse(response.to_s)
        type = index == (parts.size - 1) ? 'blob' : 'tree'
        next_file = json['tree'].detect { |tree| tree['path'] == part && tree['type'] == type }
        if type == 'blob'
          content_item = next_file
          break
        else
          next_url = next_file['url']
        end
      end

      return unless content_item

      content_response = get(content_item['url'])
      content_json = JSON.parse(content_response.to_s)
      content = Base64.decode64(content_json['content']).force_encoding('UTF-8')

      json = JSON.parse(content)
      @packages = json['dependencies'].keys if json['dependencies']
    end
  end
end
