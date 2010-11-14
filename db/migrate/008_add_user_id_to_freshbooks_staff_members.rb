class AddUserIdToFreshbooksStaffMembers < ActiveRecord::Migration
  def self.up
    add_column :freshbooks_staff_members, :user_id, :integer
  end

  def self.down
    remove_column :freshbooks_staff_members, :user_id
  end
end
