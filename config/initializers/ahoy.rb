# frozen_string_literal: true

module Ahoy
  class Store < Ahoy::DatabaseStore
  end
end

Ahoy.api = false
Ahoy.geocode = false
Ahoy.server_side_visits = :when_needed
