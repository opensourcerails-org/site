# frozen_string_literal: true

class ProjectDecorator < ApplicationDecorator
  delegate_all

  # used for background colors on a projects list
  def extracted_colors
    Miro::DominantColors.new(primary_image.url).to_hex
  end
end
