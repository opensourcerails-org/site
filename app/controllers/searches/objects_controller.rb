# frozen_string_literal: true

module Searches
  class ObjectsController < BaseController
    self.notable = true

    private

    def show_admin?
      false
    end

    def get_items
      TagCache.app_directories
    end

    def show_search_title
      "Ruby on Rails applications using #{@item.name} objects"
    end

    def index_search_title
      'Search open-source Ruby on Rails projects by object'
    end
  end
end
