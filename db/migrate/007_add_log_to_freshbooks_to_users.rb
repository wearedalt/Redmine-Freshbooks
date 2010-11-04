class AddLogToFreshbooksToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :log_to_freshbooks, :boolean
  end

  def self.down
    remove_column :users, :log_to_freshbooks
  end
end
