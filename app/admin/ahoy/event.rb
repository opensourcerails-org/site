# frozen_string_literal: true

ActiveAdmin.register Ahoy::Event do
  menu parent: 'Tracking'
  includes :visit

  filter :visit_id
  filter :time
  filter :name

  index pagination_total: false do
    id_column
    column :visit
    column :name
    column :time
  end
end
