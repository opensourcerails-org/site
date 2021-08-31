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
  resources :most_popular_projects, path: 'most-popular', only: [:index]
  resources :recently_added_projects, path: 'recently-added', only: [:index]
  resources :last_active_projects, path: 'last-active', only: [:index]
  resource :about, only: [:show]
  resource :newsletter, only: [:create]

  resource :search, only: [:show] do
    scope module: :searches do
      with_options only: %i[index show], param: :slug do
        resources :gems, path: 'by-gem'
        resources :categories, path: 'by-category'
        resources :packages, path: 'by-package'
        resources :objects, path: 'by-object'
        resources :stacks, path: 'by-stack'
      end
    end
  end

  resources :updates, only: [:index]
  resources :sitemaps, only: [:index], path: 'sitemap'
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_error', via: :all
end
