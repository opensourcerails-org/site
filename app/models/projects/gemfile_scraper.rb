# frozen_string_literal: true

# This has gone through so many iterations.
#
# It's best just to look at the Gemfile.lock
# See https://github.com/SquareSquash/web for an example of a not-so-friendly thing to parse
# and the ruby that gets evaled in a gemfile can screw this up too.
#
module Projects
  class GemfileScraper < GithubScraper
    attr_reader :gems

    def initialize(*)
      super
      @gems = []
    end

    # some weird ones:
    # https://github.com/instructure/canvas-lms/blob/master/Gemfile.d/app.rb
    # https://github.com/decidim/decidim
    # https://github.com/owen2345/camaleon-cms
    # https://github.com/solidusio/solidus/blob/master/core/solidus_core.gemspec
    def run
      files = if @project.gems_path.present?
                @project.gems_path.split(",").map { |path| path.strip.split("/") }
              else
                [['Gemfile.lock']]
              end

      files.each do |parts|
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

        content_response = get(content_item['url'])
        content = Base64.decode64(content_response.parsed_response['content']).force_encoding('UTF-8')

        parse_file(content, content_item['path'])
      end

      @gems.flatten!
    end

    private

    def parse_file(content, filename)
      if filename.end_with?('gemspec')
        parse_gemspec(content)
      elsif filename.end_with?('.lock')
        parse_lockfile(content)
      elsif filename.end_with?('.rb') || filename == 'Gemfile' # assume it's a gemfile
        parse_gemfile(content)
      else
        raise ArgumentError, "unknown parse strategy for #{filename}"
      end
    end

    def parse_lockfile(content)
      dependencies_part = content.split(/^DEPENDENCIES/)[1].split('BUNDLED WITH')[0]
      dependencies_part.lines.each do |line|
        next if line.blank?
        break if line.empty?

        value = line.scan(/([A-Za-z\-_0-9]+)\s/).flatten.first.to_s.downcase
        @gems << value
      end
    end

    def parse_gemfile(content)
      lines = content.scan(/^\s?gem\s*(?:'|")(.*)(?:'|")/).flatten
      lines.each do |line|
        @gems << line.split('"')[0].split("'")[0].split(',')[0]
      end
    end

    # @todo: LOL
    def parse_gemspec(content)
      lines = content.scan(/add.*dependency\s*(?:'|")(.*)(?:'|")/).flatten
      lines.each do |line|
        @gems << line.split('"')[0].split("'")[0].split(',')[0]
      end
    end
  end
end
