# frozen_string_literal: true

module Searches
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound do
      redirect_back(fallback_location: search_path)
    end

    class_attribute :notable, default: false
    class_attribute :includes_count, default: true

    before_action :set_items, only: [:index]
    before_action :set_item, only: [:show]
    before_action :set_projects, only: [:show]

    def index
      @includes_count = self.class.includes_count?
      @search_title = index_search_title
      set_meta_tags title: @search_title
      render layout: 'searches'
    end

    def show
      @search_title = show_search_title
      set_meta_tags title: @search_title
      ahoy.track "$viewed_#{current_type}", name: @item.name
      render layout: 'projects'
    end

    private

    def set_items
      @items = get_items
      @items, _oops = handle_sort(@items)
      @notable, @items = @items.partition { |item| item.data['notable'] } if self.class.notable?
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
      @projects = Project.slim.visible.tagged_with(@item).distinct(:id)
    end

    helper_method :active_link
    def active_link(name, url)
      if controller_name == name.pluralize
        view_context.content_tag :span, class: 'bg-dark' do
          view_context.link_to name, url, class: 'line-link px-1 text-light'
        end
      else
        view_context.link_to name, url, class: 'line-link text-dark'
      end
    end

    def current_type
      @current_type ||= self.class.name.demodulize.delete_suffix('Controller').downcase.singularize
    end

    helper_method :current_path
    def current_path(obj)
      send(path_name, obj)
    end

    def path_name
      @path_name ||= ['search', current_type, 'path'].join('_').to_sym
    end

    # unused since delegated to TagCache
    def tags_from_context(context)
      ActsAsTaggableOn::Tag.where(id: ActsAsTaggableOn::Tag.select(:id).distinct(:id).joins(:taggings).where(taggings: { context: context })).where('visible_taggings_count > 0').order('lower(name) asc')
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
  end
end
