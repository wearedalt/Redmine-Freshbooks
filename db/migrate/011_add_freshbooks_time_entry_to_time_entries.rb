class AddFreshbooksTimeEntryToTimeEntries < ActiveRecord::Migration
  def self.up
    add_column :time_entries, :freshbooks_time_entry_id, :integer
  end

  def self.down
    remove_column :time_entries, :freshbooks_time_entry_id
  end
end
