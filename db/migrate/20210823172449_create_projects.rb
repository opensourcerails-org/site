# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :rails_major_version, null: false
      t.string :github, null: false
      t.text :github_about
      t.string :website
      t.integer :contributors, null: false, default: 1
      t.integer :dependents
      t.integer :stars, null: false, default: 0
      t.integer :watchers, null: false, default: 1
      t.integer :forks, null: false, default: 0
      t.text :app, null: false, default: [], array: true

      t.timestamps
    end
    add_index :projects, :slug, unique: true
  end
end
