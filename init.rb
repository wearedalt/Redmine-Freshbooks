require 'redmine'
require 'ruby-freshbooks'
require 'redmine_freshbooks'
require 'projects_controller_patch'
require 'dispatcher'
Dispatcher.to_prepare :redmine_freshbooks do
  require_dependency 'issue'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless ProjectsController.included_modules.include? RedmineFreshbooks::ProjectsControllerPatch
    ProjectsController.send(:include, RedmineFreshbooks::ProjectsControllerPatch)
  end
end



Redmine::Plugin.register :redmine_freshbooks do
  name 'Redmine Freshbooks plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  settings :default => {'sample_setting' => 'value'}, :partial => 'settings/settings'
end
