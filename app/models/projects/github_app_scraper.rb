# frozen_string_literal: true

module Projects
  class GithubAppScraper < GithubScraper
    attr_reader :app

    def initialize(*)
      super
      @app = []
    end

    def run
      response = get("https://api.github.com/repos/#{@project.github}/git/trees/#{@project.last_commit}")
      json = JSON.parse(response.to_s)
      app = find_app(json)
      if app
        app_response = get(app['url'])
        app_json = JSON.parse(app_response)
        extract_app(app_json['tree'])
      else
        # try all once and hope for the best...
        # works for decidim and workarea
        json['tree'].select { |tree| tree['type'] == 'tree' }.each do |tree|
          tree_response = get(tree['url'])
          tree_json = JSON.parse(tree_response)
          app = find_app(tree_json)
          next unless app

          app_response = get(app['url'])
          app_json = JSON.parse(app_response)
          extract_app(app_json['tree'])
        end
      end
    end

    private

    def find_app(dir)
      dir['tree'].detect { |tree| tree['path'] == 'app' && tree['type'] == 'tree' }
    end

    def extract_app(trees)
      trees.each do |tree|
        next unless tree['type'] == 'tree'

        @app << tree['path']
      end
    end
  end
end
