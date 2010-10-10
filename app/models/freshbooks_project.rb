class FreshbooksProject < ActiveRecord::Base
  unloadable
  has_many :projects
end
