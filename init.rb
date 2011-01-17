require_dependency 'vendor/plugins/acts_as_customizable/init'
require_dependency 'vendor/plugins/acts_as_list/init'
require_dependency 'vendor/plugins/acts_as_event/init'
require_dependency 'vendor/plugins/acts_as_activity_provider/init'
require_dependency 'vendor/plugins/acts_as_searchable/init'
require_dependency 'vendor/plugins/awesome_nested_set/init'
require_dependency 'vendor/plugins/acts_as_attachable/init'
require_dependency 'vendor/plugins/acts_as_watchable/init'

require_dependency 'issue'
require_dependency 'changeset'


require 'redmine'
require 'ruby-freshbooks'
require 'redmine_freshbooks'
require 'project_patch'
require 'time_entry_patch'
require 'user_patch'
require 'dispatcher'
Dispatcher.to_prepare :redmine_freshbooks do
  if(Setting["plugin_redmine_freshbooks"]['freshbooks_enabled'] == 'yes') 
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
end



Redmine::Plugin.register :redmine_freshbooks do
  name 'Redmine Freshbooks'
  author 'phsr'
  description 'Integrates Freshbooks timelogging into Redmine'
  version '1.0.0'
  url 'http://github.com/phsr/Redmine-Freshbooks'
  author_url 'http://github.com/phsr'
  settings :default => {'freshbooks_domain' => 'YOURDOMAIN.frehsbooks.com', 'freshbooks_enabled' => 'no'}, :partial => 'settings/settings'
end
