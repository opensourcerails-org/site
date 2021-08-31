# frozen_string_literal: true

class MostPopularProjectsController < ApplicationController
  def index
    @projects = Project.slim.visible.select(:stars).order(stars: :desc)
    set_meta_tags title: 'Most popular Rails apps'
    render layout: 'projects'
  end
end
