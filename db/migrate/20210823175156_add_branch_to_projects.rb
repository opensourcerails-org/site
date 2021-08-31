# frozen_string_literal: true

class AddBranchToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :branch, :string
  end
end
