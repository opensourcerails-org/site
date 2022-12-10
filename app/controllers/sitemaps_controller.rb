# frozen_string_literal: true

class SitemapsController < ApplicationController
  skip_before_action :track_ahoy_visit
  skip_after_action :track_action

  def index
    respond_to do |f|
      f.xml do

      end
    end
  end
end
