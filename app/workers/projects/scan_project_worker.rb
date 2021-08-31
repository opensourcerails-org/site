# frozen_string_literal: true

module Projects
  class ScanProjectWorker
    include Sidekiq::Worker

    def perform(slug, first = false)
      project = Project.find_by(slug: slug)
      return unless project

      project.scan!(first)
    end
  end
end
