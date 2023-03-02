# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'pg', '~> 1.1'
gem 'bootstrap', "4.5.3"
gem 'puma', '~> 5.0'
gem 'rails', '~> 7'
gem 'redis', '~> 4.0', require: ['redis', 'redis/connection/hiredis']
gem 'sass-rails', '>= 6'
gem 'sprockets-rails'
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7'
  gem 'pry'
  gem 'pry-rails'
end

group :test do
  gem 'factory_bot_rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'database_cleaner-active_record'
  gem 'webmock'
  gem 'ffaker'
  gem 'rails-controller-testing'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
end

group :production do
  gem 'cloudflare-rails'
end

gem 'activeadmin'
gem 'activeadmin_addons'
gem 'acts-as-taggable-on'
gem 'ahoy_matey', '~> 4.0'
gem 'attr_json'
gem "aws-sdk-s3", require: false
gem 'devise', '~> 4.8'
gem 'draper', '~> 4.0'
gem 'friendly_id', '~> 5.4'
gem 'hiredis', '~> 0.6.3'
gem 'hotwire-rails'
gem 'http'
gem 'image_processing', '>= 1.2'
gem 'lograge', '~> 0.11.2'
gem 'memoist', '~> 0.16.2'
gem 'meta-tags'
gem 'miro', '~> 0.4.0'
gem 'rollbar'
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 3.1'
gem 'simple_form'
gem 'skylight', '~> 5.1'
gem 'importmap-rails'
gem 'geocoder'

gem "redcarpet", "~> 3.6"
