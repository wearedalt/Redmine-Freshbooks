class FreshbooksProject < ActiveRecord::Base
  unloadable
  has_many :projects
  has_many :freshbooks_project_staffings
  has_many :freshbooks_staff_members, :through => :freshbooks_project_staffings
end
