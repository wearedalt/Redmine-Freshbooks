class FreshbooksProject < ActiveRecord::Base
  unloadable
  has_one :projects
  has_many :freshbooks_project_staffings
  has_many :freshbooks_staff_members, :through => :freshbooks_project_staffings
  has_and_belongs_to_many :freshbooks_tasks
end
