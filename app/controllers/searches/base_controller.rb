# frozen_string_literal: true

module Searches
  class BaseController < ApplicationController
    class_attribute :notable, default: false
    class_attribute :includes_count, default: true

    rescue_from ActiveRecord::RecordNotFound do
      redirect_back(fallback_location: search_path)
    end

    before_action :set_items, only: [:index]
    before_action :set_item, only: [:show]
    before_action :set_projects, only: [:show]

    def index
      @includes_count = self.class.includes_count?
      @search_title = index_search_title
      set_meta_tags title: @search_title
      @includes_search = true
      render layout: 'searches'
    end

    def show
      @search_title = show_search_title
      set_meta_tags title: @search_title
      @includes_search = false
      ahoy.track "$viewed_#{controller_name}", name: @item.name
      render layout: 'projects'
    end

    private

    def set_items
      @items = get_items
      @items, _oops = handle_sort(@items)
      @notable, @items = @items.partition { |item| item.data['notable'] } if self.class.notable?
    end

    def index_search_title
      raise NotImplementedError
    end

    def get_items
      raise NotImplementedError
    end

    def show_search_title
      raise NotImplementedError
    end

    # it works, whatever
    def handle_sort(*items)
      return *(items.map { |item| sorted_by_popular(item) }) if params[:sort] == 'popular'

      # needs the explicit return
      (items.map { |item| sorted_by_name(item) })
    end

    def sorted_by_popular(collection)
      if collection.is_a?(Array)
        collection.sort_by { |item| item['visible_taggings_count'] * -1 }
      else
        collection.reorder('visible_taggings_count desc, lower(name) asc')
      end
    end

    def sorted_by_name(collection)
      if collection.is_a?(Array)
        collection.sort_by { |item| item['name'].downcase }
      else
        collection.reorder('lower(name) asc, visible_taggings_count desc')
      end
    end

    def set_item
      @item = ActsAsTaggableOn::Tag.friendly.find(params[:slug])
    end

    def set_projects
      @projects = Project.slim.visible.tagged_with(@item).order(name: :asc).distinct(:id)
    end
  end
end
