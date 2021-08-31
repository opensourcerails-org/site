# frozen_string_literal: true

module Bulk
  module Projects
    class SyncProjectsWorker
      include Sidekiq::Worker

      def perform
        Project.visible.select(:slug).all.each do |prj|
          ::Projects::SyncProjectWorker.perform_async(prj.slug)
        end
      end
    end
  end
end
