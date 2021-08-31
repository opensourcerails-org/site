# frozen_string_literal: true

module Searches
  class GemsController < BaseController
    self.notable = true
    self.includes_count = true

    private

    def index_search_title
      'Search open-source Ruby on Rails projects by gem'
    end

    def get_items
      TagCache.gems
    end

    def show_search_title
      "Open-source Ruby on Rails projects using #{@item.name} gem"
    end
  end
end
