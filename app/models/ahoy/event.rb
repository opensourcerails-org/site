# frozen_string_literal: true

module Ahoy
  class Event < ApplicationRecord
    include Ahoy::QueryMethods

    self.table_name = 'ahoy_events'

    belongs_to :visit
  end
end
