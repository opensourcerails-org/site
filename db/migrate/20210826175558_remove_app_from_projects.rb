# frozen_string_literal: true

class RemoveAppFromProjects < ActiveRecord::Migration[6.1]
  def change
    remove_column :projects, :app
  end
end
