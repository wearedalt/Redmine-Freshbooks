class FreshbooksProjectStaffing < ActiveRecord::Base
  unloadable
  belongs_to :freshbooks_staff_member
  belongs_to :freshbooks_project
end
