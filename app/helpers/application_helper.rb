# frozen_string_literal: true

module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(template: "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

  def render_projects(projects, lead: nil, title: nil, classes: nil, &block)
    render template: '/projects/projects',
           locals: { projects: projects, lead: lead, title: title, classes: classes, meta: block }
  end

  def hide_admin?
    cookies[:hide_admin]
  end

  # shit but whatever
  def admin_panel(&block)
    if admin_user_signed_in?
      content_tag(:div, id: :admin, class: 'card card-body') do
        if hide_admin?
          concat(link_to('toggle admin', "/admin/dashboard/toggle_admin?return_to=#{request.path}", remote: true,
                                                                                                    onclick: "admin.querySelector('.d-none').classList.remove('d-none');this.remove()"))
          concat(content_tag(:div, class: 'd-none') do
                   yield block
                   concat(link_to('&times;'.html_safe,
                                  "/admin/dashboard/toggle_admin?return_to=#{request.path}", remote: true, style: 'text-align: right; position: absolute !important; right: 5px; top: -4px; font-size: 20px;', onclick: 'document.getElementById("admin").classList.add("d-none")'))
                 end)
        else
          yield block
          concat(link_to('&times;'.html_safe, "/admin/dashboard/toggle_admin?return_to=#{request.path}", remote: true,
                                                                                                         style: 'text-align: right; position: absolute !important; right: 5px; top: -4px; font-size: 20px;', onclick: 'document.getElementById("admin").classList.add("d-none")'))
        end
      end
    end
  end
end
