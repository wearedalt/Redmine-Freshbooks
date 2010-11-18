class CreateFreshbooksProjectsFreshbooksTasks < ActiveRecord::Migration
  def self.up
    create_table :freshbooks_projects_freshbooks_tasks, :id => false do |t|
      t.column :freshbooks_project_id, :integer
      t.column :freshbooks_task_id, :integer

    end
  end

  def self.down
    drop_table :freshbooks_projects_freshbooks_tasks
  end
end