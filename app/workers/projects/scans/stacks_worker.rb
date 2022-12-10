module Projects
  module Scans
    class StacksWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        return unless project

        project.helpers.analyze_stacks!
      end

      def after_worker(slug, _)
        PulseWorker.perform_async(slug)
      end
    end
  end
end
