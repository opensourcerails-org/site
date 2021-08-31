# frozen_string_literal: true

class AddPulseToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :pulse, :integer
  end
end
