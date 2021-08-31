module ProjectsHelper
  def cache_key_for_projects(projects = @projects)
    max_updated_at = (projects.except(:group, :order).maximum(:updated_at) || Date.today).to_s(:number)
    "projects/#{projects.map(&:id).join('-')}-#{controller_name}-#{max_updated_at}"
  end

  def cache_key_for_project(project = @project)
    cache_key_elements = common_project_cache_keys
    cache_key_elements += [
      project.cache_key_with_version,
    ]

    cache_key_elements.compact.join('/')
  end

  # different meta has different caches, unfortunately.
  # still speeds up and reduces allocations
  def common_project_cache_keys
    [controller_name]
  end
end
