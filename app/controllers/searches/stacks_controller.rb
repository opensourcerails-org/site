# frozen_string_literal: true

module Searches
  class StacksController < BaseController
    private

    def set_items
      @frontend_stacks = TagCache.frontend_stacks
      @backend_stacks = TagCache.backend_stacks
      @frontend_stacks, @backend_stacks = *handle_sort(@frontend_stacks, @backend_stacks)
    end

    def index_search_title
      'Search open-source Ruby on Rails projects by stack'
    end

    def show_search_title
      "Ruby on Rails projects using #{@item.name} gem"
    end
  end
end
