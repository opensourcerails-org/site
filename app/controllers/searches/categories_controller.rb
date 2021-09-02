# frozen_string_literal: true

module Searches
  class CategoriesController < BaseController
    private

    def index_search_title
      'Search open-source Ruby on Rails projects by category'
    end

    def get_items
      TagCache.categories
    end

    def show_search_title
      "#{@item.name} Ruby on Rails projects"
    end
  end
end
