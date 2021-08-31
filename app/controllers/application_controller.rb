# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout 'inner'

  after_action :track_action, unless: -> { controller_name.start_with?('admin') }
  skip_before_action :track_ahoy_visit, if: -> { controller_name.start_with?('admin') }

  private

  helper_method :default_meta_tags
  def default_meta_tags
    {
      site: 'OpenSourceRails.org',
      reverse: true,
      separator: '&mdash;'.html_safe,
      twitter: {
        card: :summary,
        image: meta_tags.meta_tags.dig(:og, :image) || 'https://opensourcerails.org/android-chrome-512x512.png',
        description: meta_tags[:description],
        creator: '@joshmn',
        title: "#{meta_tags[:title]} - OpenSourceRails.org"
      },
      og: {
        site_name: 'OpenSourceRails.org',
        url: request.url,
        image: 'https://opensourcerails.org/android-chrome-512x512.png',
        title: meta_tags[:title],
        description: meta_tags[:description]
      }
    }
  end

  def track_action
    ahoy.track '$view', request.path_parameters
  end
end
