class FreshbooksTask < ActiveRecord::Base
  unloadable
  has_and_belongs_to_many :freshbooks_projects
end
