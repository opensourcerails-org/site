# frozen_string_literal: true

class AddMetaLastUpdatedAtToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :meta_last_updated_at, :datetime
  end
end
