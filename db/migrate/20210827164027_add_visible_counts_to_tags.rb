# frozen_string_literal: true

class AddVisibleCountsToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :visible_taggings_count, :integer, default: 0, null: false
  end
end
