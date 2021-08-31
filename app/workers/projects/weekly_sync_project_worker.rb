# frozen_string_literal: true

module Projects
  class WeeklySyncProjectWorker
    include Sidekiq::Worker

    def perform(slug)
      project = Project.find_by(slug: slug)
      return unless project

      project.weekly_sync!
    end
  end
end
