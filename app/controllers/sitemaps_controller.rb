# frozen_string_literal: true

class SitemapsController < ApplicationController
  skip_before_action :track_ahoy_visit
  skip_after_action :track_action

  def index
    respond_to do |f|
      f.any do
        render template: 'sitemaps/index.xml.builder'
      end
    end
  end
end
