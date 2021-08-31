# frozen_string_literal: true

ActiveAdmin.register Ahoy::Visit do
  menu parent: 'Tracking'
  index pagination_total: false

  filter :ip
  filter :visitor_token
  filter :landing_page
  filter :user_agent_string

  show do
    columns do
      column span: 1 do
        attributes_table do
          resource.attributes.each do |k, _v|
            row k.to_sym
          end
        end
      end
      column span: 3 do
        panel 'Events' do
          table_for resource.events do
            column :name
            column :properties
            column :time
          end
        end
      end
    end
  end
end
