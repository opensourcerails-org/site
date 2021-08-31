# frozen_string_literal: true

module Projects
  class SyncProjectWorker
    include Sidekiq::Worker

    def perform(slug)
      project = Project.find_by(slug: slug)
      return unless project

      project.sync!
    end
  end
end
