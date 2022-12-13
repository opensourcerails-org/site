# frozen_string_literal: true

class SearchesController < ApplicationController
  layout 'application'

  def show
    set_meta_tags title: 'Search Popular Open-Source Ruby on Rails apps'
  end
end
