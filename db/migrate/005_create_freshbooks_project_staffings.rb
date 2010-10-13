class CreateFreshbooksProjectStaffings < ActiveRecord::Migration
  def self.up
    create_table :freshbooks_project_staffings do |t|
      t.column :freshbooks_project_id, :int
      t.column :freshbooks_staff_member_id, :int
    end
  end

  def self.down
    drop_table :freshbooks_project_staffings
  end
end
