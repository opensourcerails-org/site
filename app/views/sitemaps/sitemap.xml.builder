# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  Project.tag_types.each do |type|
    next if type == :license

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

    xml.url do
      xml.loc send("search_#{type.to_s.pluralize}_url")
      xml.changefreq 'daily'
    end

    ActsAsTaggableOn::Tag.for_context(type).each do |tag|
      xml.url do
        xml.loc send("search_#{type}_url".to_sym, tag)
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
    xml.loc last_active_projects_url
    xml.changefreq 'daily'
  end
  xml.url do
    xml.loc projects_url
    xml.changefreq 'daily'
  end

  Project.select(:slug).visible.each do |project|
    xml.url do
      xml.loc project_url(project)
      xml.changefreq 'daily'
    end
  end
end
