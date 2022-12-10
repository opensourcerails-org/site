module Projects
  module Scans
    class AppWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        return unless project

        project.helpers.scrape_app!
      end

      def after_worker(slug, _)
        GemfileWorker.perform_async(slug)
      end
    end
  end
end
