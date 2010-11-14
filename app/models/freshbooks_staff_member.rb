class FreshbooksStaffMember < ActiveRecord::Base
  unloadable
  has_many :freshbooks_project_staffings
  has_many :freshbooks_projects, :through => :freshbooks_project_staffings
  belongs_to :user
end
