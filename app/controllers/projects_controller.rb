# frozen_string_literal: true

class ProjectsController < ApplicationController
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
    set_meta_tags og: { image: cdn_proxy_url(@project.primary_image) } if @project.primary_image.present?
    ahoy.track '$viewed_project', slug: params[:slug]
  end
end
