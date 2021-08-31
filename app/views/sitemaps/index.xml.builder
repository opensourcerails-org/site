# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  Project.tag_types.each do |type|
    next if type == :license
    next if type == :adjectives

    if type == :app_directories
      xml.url do
        xml.loc search_objects_url
        xml.changefreq 'daily'
      end

      ActsAsTaggableOn::Tag.for_context(:app_directories).each do |tag|
        xml.url do
          xml.loc search_object_url(tag.name)
          xml.changefreq 'daily'
        end
      end

      next
    end

    route_collection = "search_#{type.to_s.pluralize}_url".to_s
    route_record = "search_#{type.to_s.singularize}_url".to_s

    if route_collection.to_s.end_with?('stacks_url')
      route_collection = :search_stacks_url
      route_record = :search_stack_url
    end

    xml.url do
      xml.loc send(route_collection)
      xml.changefreq 'daily'
    end

    ActsAsTaggableOn::Tag.for_context(type).each do |tag|
      xml.url do
        xml.loc send(route_record, tag)
        xml.changefreq 'daily'
      end
    end
  end

  xml.url do
    xml.loc about_url
    xml.changefreq 'daily'
  end

  xml.url do
    xml.loc search_url
    xml.changefreq 'daily'
  end

  xml.url do
    xml.loc recently_added_projects_url
    xml.changefreq 'daily'
  end

  xml.url do
    xml.loc most_popular_projects_url
    xml.changefreq 'daily'
  end

  xml.url do
    xml.loc last_active_projects_url
    xml.changefreq 'daily'
  end

  xml.url do
    xml.loc projects_url
    xml.changefreq 'daily'
  end

  xml.url do
    xml.loc updates_url
    xml.changefreq 'daily'
  end

  Project.select(:slug).visible.each do |project|
    xml.url do
      xml.loc project_url(project)
      xml.changefreq 'daily'
    end
  end
end
