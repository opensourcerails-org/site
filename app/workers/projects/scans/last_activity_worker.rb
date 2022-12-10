module Projects
  module Scans
    class LastActivityWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        return unless project

        project.helpers.scrape_last_activity!
      end

      def after_worker(slug, _)
        AppWorker.perform_async(slug)
      end
    end
  end
end
