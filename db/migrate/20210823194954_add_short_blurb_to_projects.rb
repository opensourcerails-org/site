# frozen_string_literal: true

class AddShortBlurbToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :short_blurb, :text
  end
end
