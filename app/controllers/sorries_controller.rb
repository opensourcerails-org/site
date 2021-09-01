class SorriesController < ApplicationController
  skip_forgery_protection
  skip_after_action :track_action

  def create
    ahoy.track(params[:name], JSON.parse(params[:properties]))
    head 200
  end
end
