module Projects
  module Scans
    class PackagesWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        return unless project

        project.helpers.scrape_packages!
      end

      def after_worker(slug, _)
        StacksWorker.perform_async(slug)
      end
    end
  end
end
