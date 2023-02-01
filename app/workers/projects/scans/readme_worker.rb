module Projects
  module Scans
    class ReadmeWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        throw(:abort) unless project

        project.helpers.scrape_readme!
      end

      def after_worker(slug, _)
        LastActivityWorker.perform_async(slug)
      end
    end
  end
end
