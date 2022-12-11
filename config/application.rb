# frozen_string_literal: true

require_relative 'boot'

%w[
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_text/engine
  action_mailer/railtie
  sprockets/railtie
].each do |railtie|
  require railtie
rescue LoadError
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load if defined?(Dotenv)

module Opensourcerails
  class Application < Rails::Application
    config.active_storage.resolve_model_to_route = :rails_storage_proxy
    config.active_storage.urls_expire_in = 30.years

    config.load_defaults 6.1
    config.skylight.environments = ['production']
    config.exceptions_app = routes
  end
end
