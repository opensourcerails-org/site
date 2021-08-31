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

  def current_path_for_tag(tag)
    send(path_name, tag)
  end

  private

  def current_type
    controller_name.singularize
  end

  def path_name
    @path_name ||= ['search', current_type, 'path'].join('_').to_sym
  end
end
