# frozen_string_literal: true

ActiveAdmin.register Update do
  permit_params :date, :title, :content

  filter :date

  form do |f|
    f.inputs do
      f.input :title
      f.input :date, as: :date_time_picker
      f.li do
        f.label :content, class: 'trix-editor-label'
        f.rich_text_area :content
      end
    end
    actions
  end

  show do
    attributes_table do
      row :title
      row :date
      row :content do
        resource.content.body.html_safe
      end
    end
  end
end
