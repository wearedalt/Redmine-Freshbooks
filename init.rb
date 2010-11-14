require 'redmine'
require 'ruby-freshbooks'
require 'redmine_freshbooks'
require 'project_patch'
require 'time_entry_patch'
require 'user_patch'
require 'dispatcher'
Dispatcher.to_prepare :redmine_freshbooks do
  require_dependency 'project'
  require_dependency 'time_entry'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Project.included_modules.include? RedmineFreshbooks::ProjectPatch
    Project.send(:include, RedmineFreshbooks::ProjectPatch)
  end
  unless TimeEntry.included_modules.include? RedmineFreshbooks::TimeEntryPatch
    TimeEntry.send(:include, RedmineFreshbooks::TimeEntryPatch)
  end
  unless User.included_modules.include? RedmineFreshbooks::UserPatch
    User.send(:include, RedmineFreshbooks::UserPatch)
  end
end



Redmine::Plugin.register :redmine_freshbooks do
  name 'Redmine Freshbooks plugin'
  author 'phsr'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://github.com/phsr/Redmine-Freshbooks'
  author_url 'http://github.com/phsr'
  settings :default => {'freshbooks_domain' => 'YOURDOMAIN.frehsbooks.com'}, :partial => 'settings/settings'
end
