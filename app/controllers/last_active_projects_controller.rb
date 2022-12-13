# frozen_string_literal: true

class LastActiveProjectsController < ApplicationController
  def index
    @projects = Project.slim.visible.select(:last_activity_at).order(last_activity_at: :desc)
    set_meta_tags title: 'Active Open-Source Ruby on Rails apps'
    render layout: 'projects'
  end
end
