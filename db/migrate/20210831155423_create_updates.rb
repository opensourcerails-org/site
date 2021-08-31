# frozen_string_literal: true

class CreateUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :updates do |t|
      t.datetime :date
      t.string :title

      t.timestamps
    end
  end
end
