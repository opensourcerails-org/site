module ProjectsHelper
  def cache_key_for_projects(projects = @projects)
    max_updated_at = (projects.except(:group, :order).maximum(:updated_at) || Date.today).to_s(:number)
    "projects/#{projects.map(&:id).join('-')}-#{controller_name}-#{max_updated_at}"
  end
end
