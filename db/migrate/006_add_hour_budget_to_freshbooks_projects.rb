class AddHourBudgetToFreshbooksProjects < ActiveRecord::Migration
  def self.up
    add_column :freshbooks_projects, :hour_budget, :int
  end

  def self.down
    remove_column :freshbooks_projects, :hour_budget
  end
end


