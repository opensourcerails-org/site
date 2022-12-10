# frozen_string_literal: true

class ProjectDecorator < ApplicationDecorator
  delegate_all

  # used for background colors on a projects list
  def extracted_colors
    Miro::DominantColors.new(Rails.application.routes.url_helpers.cdn_proxy_url(primary_image.blob)).to_hex
  end
end
