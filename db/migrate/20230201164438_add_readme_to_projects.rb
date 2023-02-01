class AddReadmeToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :readme, :text
  end
end
