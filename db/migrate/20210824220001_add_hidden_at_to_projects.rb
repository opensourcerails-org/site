# frozen_string_literal: true

class AddHiddenAtToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :hidden_at, :datetime
    add_index :projects, :hidden_at
  end
end
