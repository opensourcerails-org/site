module Projects
  module Scans
    module Pipeline
      def perform(slug)
        catch :abort do
          result = super
          self.after_worker(slug, result)
        end
      end
    end

    class BaseWorker
      def self.inherited(klass)
        klass.prepend Pipeline
      end

      include Sidekiq::Worker

      private

      def find_project(slug)
        Project.find_by(slug: slug)
      end
    end
  end
end
