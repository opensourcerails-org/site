module Projects
  module Scans
    class MetaWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        throw(:abort) unless project

        project.helpers.scrape_meta!
      end

      def after_worker(slug, _)
        LastActivityWorker.perform_async(slug)
      end
    end
  end
end
