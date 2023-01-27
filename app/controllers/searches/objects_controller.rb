# frozen_string_literal: true

module Searches
  class ObjectsController < BaseController
    self.notable = true

    def index
      set_meta_tags description: "A list of open-source Ruby on Rails apps by object type."
      super
    end

    def show
      set_meta_tags description: "A list of open-source Ruby on Rails apps using the #{@item.name} object pattern."
      super
    end

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
