class AddFreshbooksApiKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :freshbooks_api_key, :string
  end

  def self.down
    remove_column :users, :freshbooks_api_key
  end
end
