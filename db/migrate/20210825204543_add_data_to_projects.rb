# frozen_string_literal: true

class AddDataToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :data, :json, default: {}, null: false
  end
end
