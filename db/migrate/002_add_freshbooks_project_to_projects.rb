class AddFreshbooksProjectToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :freshbooks_project_id, :int
  end

  def self.down
    remove_column :projects, :freshbooks_project_id
  end
end
