# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_forgery_protection

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to projects_path
  end

  def index
    @projects = Project.slim.visible.select(:created_at).order(created_at: :desc)
    set_meta_tags description: 'A comprehensive, curated list of open-source Ruby on Rails applications.'
    render layout: 'projects'
  end

  def show
    @project = Projects::ShowDecorator.new(Project.friendly.visible.find(params[:slug]))
    set_meta_tags description: @project.github_about, title: @project.name,
                  og: { title: "#{@project.name} on OpenSourceRails.org" }
    set_meta_tags og: { image: @project.primary_image.url } if @project.primary_image.present?
    ahoy.track '$viewed_project', slug: params[:slug]
  end

  def update
    if params[:api_key] == ENV['API_KEY']
      @project = Project.friendly.visible.find(params[:slug])
      @project.primary_image.attach(params.permit(:primary_image)[:primary_image])
      return head :ok
    end
  end
end
