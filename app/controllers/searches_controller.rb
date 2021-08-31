# frozen_string_literal: true

class SearchesController < ApplicationController
  layout 'application'

  def show
    set_meta_tags title: 'Search popular open-source Ruby on Rails apps'
  end
end
