# frozen_string_literal: true

class AddDataToActsAsTaggableOnTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :data, :jsonb, default: {}, null: false
    add_index  :tags, :data, using: :gin
  end
end
