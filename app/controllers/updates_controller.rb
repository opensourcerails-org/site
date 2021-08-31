# frozen_string_literal: true

class UpdatesController < ApplicationController
  layout 'projects'
  def index
    @updates = Update.all.order(date: :desc)
  end
end
