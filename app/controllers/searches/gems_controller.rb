# frozen_string_literal: true

module Searches
  class GemsController < BaseController
    self.notable = true
    self.includes_count = true

    def show
      @url = "https://rubygems.org/search?query=#{@item.name}"
      set_meta_tags description: "A list of open-source Ruby on Rails apps using the #{@item.name} gem."

      super
    end

    private

    def index_search_title
      'Search open-source Ruby on Rails projects by gem'
    end

    def get_items
      TagCache.gems
    end

    def show_search_title
      "Ruby on Rails projects using #{@item.name} gem"
    end
  end
end
