# frozen_string_literal: true

class AddSlugToActsAsTaggableOnTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :slug, :string, null: false
    add_index :tags, :slug, unique: true
  end
end
