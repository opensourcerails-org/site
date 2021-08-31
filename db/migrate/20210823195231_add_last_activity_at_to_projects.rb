# frozen_string_literal: true

class AddLastActivityAtToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :last_activity_at, :datetime
  end
end
