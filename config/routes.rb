# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  constraints(->(request) { request.env['warden'].authenticate? }) do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  direct :cdn_proxy do |model, options|
    if model.respond_to?(:signed_id)
      route_for(
        :rails_service_blob_proxy,
        model.signed_id,
        model.filename,
        options.merge(host: ENV['CDN_HOST'] || 'localhost:3000')
      )
    else
      signed_blob_id = model.blob.signed_id
      variation_key  = model.variation.key
      filename       = model.blob.filename
      route_for(
        :rails_blob_representation_proxy,
        signed_blob_id,
        variation_key,
        filename,
        options.merge(host: ENV['CDN_HOST'] || 'localhost:3000')
      )
    end
  end

  root 'projects#index'

  resources :projects, only: %i[index show], param: :slug
  resources :most_popular_projects, path: 'most-popular-open-source-ruby-on-rails-apps', only: [:index]
  resources :recently_added_projects, path: 'newest-open-source-ruby-on-rails-apps', only: [:index]
  resources :last_active_projects, path: 'active-open-source-ruby-on-rails-apps', only: [:index]

  resource :search, only: [:show] do
    scope module: :searches do
      with_options param: :slug do
        resources :gems, path: 'open-source-ruby-on-rails-apps-using-gem', only: [:index]
        resources :categories, path: 'open-source-ruby-on-rails-apps-by-category', only: [:index, :show]
        resources :packages, path: 'open-source-ruby-on-rails-apps-using-package', only: [:index]
        resources :objects, path: 'open-source-ruby-on-rails-apps-by-objects', only: [:index]
        resources :stacks, path: 'open-source-ruby-on-rails-apps-using-stack', only: [:index]
      end
    end
  end

  scope module: :searches do
    with_options param: :slug do
      get 'open-source-ruby-on-rails-apps-using-:slug-gem' => 'gems#show', as: :search_gem
      get 'open-source-ruby-on-rails-apps-using-:slug-package' => 'packages#show', as: :search_package
      get 'open-source-ruby-on-rails-apps-using-:slug-objects' => 'objects#show', as: :search_object
      get 'open-source-ruby-on-rails-apps-using-:slug-stack' => 'stacks#show', as: :search_stack
    end
  end

  resource :about, only: [:show]
  resource :newsletter, only: [:show, :create]
  resource :sorry, only: [:create]
  resources :updates, only: [:index]
  resources :sitemaps, only: [:index], path: 'sitemap', defaults: { format: :xml }

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_error', via: :all
end
