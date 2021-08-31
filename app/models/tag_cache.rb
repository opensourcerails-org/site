# frozen_string_literal: true

class TagCache
  class << self
    extend Memoist

    def gems
      tags_from_context(:gems)
    end
    memoize :gems

    def app_directories
      tags_from_context(:app_directories)
    end
    memoize :app_directories

    def packages
      tags_from_context(:packages)
    end
    memoize :packages

    def categories
      tags_from_context(:categories)
    end
    memoize :categories

    def stacks
      [backend_stacks + frontend_stacks].flatten
    end
    memoize :stacks

    def backend_stacks
      tags_from_context(:backend_stack)
    end
    memoize :backend_stacks

    def frontend_stacks
      tags_from_context(:frontend_stack)
    end
    memoize :frontend_stacks

    private

    def tags_from_context(context)
      ActsAsTaggableOn::Tag.where(id: ActsAsTaggableOn::Tag.select(:id).distinct(:id).joins(:taggings).where(taggings: { context: context })).where('visible_taggings_count > 0').order('lower(name) asc').to_a
    end
  end
end
