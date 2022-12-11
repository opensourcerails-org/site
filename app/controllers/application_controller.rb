# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout 'inner'

  if Rails.env.production?
    before_action do
      if self.request.host == "opensourcerails.org" || request.host == 'www.opensourcerails.org'
        redirect_to "https://opensourcerails.org#{request.path}", status: :found, allow_other_host: true
      end
    end
  end
  after_action :track_action, if: -> { track_action? }
  skip_before_action :track_ahoy_visit, if: -> { !track_action? }

  private

  def obvious_error_occurred?
    controller_name == 'errors'
  end

  def track_action?
    !admin_path? && !obvious_error_occurred?
  end

  def admin_path?
    request.path.start_with?('/admin')
  end

  def track_action
    ahoy.track '$view', request.path_parameters
  end
end
