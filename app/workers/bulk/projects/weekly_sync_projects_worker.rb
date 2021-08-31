# frozen_string_literal: true

module Bulk
  module Projects
    class WeeklySyncProjectsWorker
      include Sidekiq::Worker

      def perform
        Project.visible.select(:slug).all.each do |prj|
          ::Projects::WeeklySyncProjectWorker.perform_async(prj.slug)
        end
      end
    end
  end
end
