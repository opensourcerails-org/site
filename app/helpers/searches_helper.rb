module SearchesHelper
  def active_link(name, url)
    if controller_name == name.pluralize
      content_tag :span, class: 'bg-dark' do
        link_to name, url, class: 'line-link px-1 text-light'
      end
    else
      link_to name, url, class: 'line-link text-dark'
    end
  end

  def current_path(obj)
    send(path_name, obj)
  end

  private

  def current_type
    controller_name
  end

  def path_name
    @path_name ||= ['search', current_type, 'path'].join('_').to_sym
  end
end
