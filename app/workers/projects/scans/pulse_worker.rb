module Projects
  module Scans
    class PulseWorker < BaseWorker
      def perform(slug)
        project = find_project(slug)
        return unless project

        project.helpers.check_pulse!
      end

      def after_worker(slug, _)
        # do nothing
      end
    end
  end
end
