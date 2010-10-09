require 'redmine'
require 'ruby-freshbooks'
require_dependency 'redmine_freshbooks/hooks'

Redmine::Plugin.register :redmine_freshbooks do
  name 'Redmine Freshbooks plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  settings :default => {'sample_setting' => 'value'}, :partial => 'settings/settings'
end
