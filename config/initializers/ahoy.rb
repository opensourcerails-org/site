# frozen_string_literal: true

module Ahoy
  class Store < Ahoy::DatabaseStore
    def user
      nil
    end
  end
end

Ahoy.api = false
Ahoy.geocode = true
Ahoy.server_side_visits = :when_needed
