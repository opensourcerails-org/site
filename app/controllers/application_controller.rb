# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout 'inner'

  after_action :track_action, unless: :admin_path?
  skip_before_action :track_ahoy_visit, if: :admin_path?

  private

  def admin_path?
    request.path.start_with?('/admin')
  end

  def track_action
    ahoy.track '$view', request.path_parameters
  end
end
