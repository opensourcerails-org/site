# frozen_string_literal: true

class AddCommitSha1ToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :last_commit, :string
  end
end
