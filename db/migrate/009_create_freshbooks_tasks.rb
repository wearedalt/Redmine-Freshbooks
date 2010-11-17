class CreateFreshbooksTasks < ActiveRecord::Migration
  def self.up
    create_table :freshbooks_tasks do |t|
      t.column :name, :string, :null => false
      t.column :task_id, :integer, :null => false, :unique => true
      t.column :rate, :decimal, :precision => 15, :scale => 2
      t.column :billable, :integer
      t.column :description, :string
    end
  end

  def self.down
    drop_table :freshbooks_tasks
  end
end