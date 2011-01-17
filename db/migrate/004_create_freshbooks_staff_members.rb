class CreateFreshbooksStaffMembers < ActiveRecord::Migration
  def self.up
    create_table :freshbooks_staff_members do |t|
      t.column :city, :string
      t.column :staff_id, :int
      t.column :country, :string
      t.column :street1, :string
      t.column :username, :string
      t.column :rate, :decimal, :precision => 15, :scale => 2
      t.column :street2, :string
      t.column :business_phone, :string
      t.column :last_name, :string
      t.column :first_name, :string
      t.column :email, :string
      t.column :mobile_phone, :string
      t.column :state, :string
    end
  end

  def self.down
    drop_table :freshbooks_staff_members
  end
end
