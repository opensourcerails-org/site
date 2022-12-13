# frozen_string_literal: true

class RecentlyAddedProjectsController < ApplicationController
  def index
    @projects = Project.slim.visible.select(:created_at).order(created_at: :desc)
    set_meta_tags title: 'Newest Open-Source Ruby on Rails Apps'
    render layout: 'projects'
  end
end
