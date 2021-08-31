# frozen_string_literal: true

namespace :importer do
  task import: :environment do
    response = HTTP.get('https://raw.githubusercontent.com/opensourcerails/opensourcerails/master/data/projects.yml')
    yaml = YAML.safe_load(response.to_s)
    yaml.each do |item|
      project = Project.find_by(slug: item['id'])
      next if project

      project = Project.new(slug: item['id'], name: item['title'], description: item['tagline'],
                            github: item['github_project'], website: item['site_url'])
      project.category_list = item['categories']
      project.rails_major_version = 5
      project.save!
    end
  end
end
