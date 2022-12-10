module Projects
  module Scans
    class GemfileWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        return unless project

        project.helpers.scrape_gemfile!
      end

      def after_worker(slug, _)
        PackagesWorker.perform_async(slug)
      end
    end
  end
end
