# frozen_string_literal: true

class ErrorsController < ApplicationController
  layout 'base'

  def not_found; end

  def internal_error; end
end
