class CreateFreshbookProjects < ActiveRecord::Migration
  def self.up
    create_table :freshbooks_projects do |t|
      t.column :name, :string, :null => false
      t.column :project_id, :integer, :null => false, :unique => true
      t.column :rate, :decimal, :precision => 15, :scale => 2
      t.column :client_id, :integer
      t.column :bill_method, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :freshbook_projects
  end
end
