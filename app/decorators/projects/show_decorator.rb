# frozen_string_literal: true

module Projects
  class ShowDecorator < ::ProjectDecorator
    MOST_POPULAR_LIMIT = 10

    def adjectives
      tags_for_context(:adjectives)
    end

    def categories
      tags_for_context(:categories)
    end

    def gems
      @gems ||= tags_for_context(:gems)
    end

    # because we're loading these as a hash for performance, do the ordering ourselves.
    def most_popular_gems
      gems.sort_by { |gem| gem['visible_taggings_count'] }.last(MOST_POPULAR_LIMIT)
    end

    # because we're loading these as a hash for performance, do the ordering ourselves.
    def most_popular_packages
      packages.sort_by { |gem| gem['visible_taggings_count'] }.last(MOST_POPULAR_LIMIT)
    end

    def packages
      @packages ||= tags_for_context(:packages)
    end

    def app_directories
      tags_for_context(:app_directories)
    end

    # eh not ready yet.
    # def similar
    #   Project.tagged_with(object.backend_stack.pluck(:name), :on => :backend_stack, :any => true)
    # end

    private

    # reduce memory by not loading a ton of shit into memory
    # crazy concept
    def tags_for_context(context)
      ActsAsTaggableOn::Tag.connection.exec_query(object.public_send(context).order('lower(name) asc').to_sql).to_a
    end
  end
end
