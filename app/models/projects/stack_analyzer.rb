# frozen_string_literal: true

module Projects
  class StackAnalyzer
    FRONTEND_STACKS = %w[vue react svelte stimulus alpinejs preact backbone tailwindcss bootstrap bulma angular
                         @hotwired/turbo gulp parcel rollup browserify snowpack babel].freeze
    BACKEND_STACKS = %w[sidekiq grape pg mysql2 flipper elasticsearch-rails sinatra graphql delayed_job que redis elasticsearch
                        bunny pg_search thinking-sphinx webpacker vite-ruby solr delayed_job_active_record].freeze

    attr_reader :frontend, :backend

    def initialize(project)
      @project = project
      @frontend_packages = (FRONTEND_STACKS + TagCache.frontend_stacks.pluck(:name) + ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: ["frontend_stack", "packages"] }).where("data->>'stack' = ?", 'true').distinct(:id).pluck(:name)).uniq
      @backend_packages = (BACKEND_STACKS + TagCache.backend_stacks.pluck(:name) + ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: ["backend_stack", "gems"] }).where("data->>'stack' = ?", 'true').distinct(:id).pluck(:name)).uniq
      @backend = []
      @frontend = []
    end

    def run
      @frontend = @project.packages.pluck(:name) & @frontend_packages
      @backend = @project.gems.pluck(:name) & @backend_packages
    end
  end
end
