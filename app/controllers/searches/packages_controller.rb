# frozen_string_literal: true

module Searches
  class PackagesController < BaseController
    self.notable = true

    private

    def index_search_title
      'Search open-source Ruby on Rails projects by package'
    end

    def get_items
      TagCache.packages
    end

    def show_search_title
      "Open-source Ruby on Rails projects using #{@item.name} package"
    end
  end
end
