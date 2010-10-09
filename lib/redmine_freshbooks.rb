require File.join(File.dirname(__FILE__), 'redmine_freshbooks/hooks')
module RedmineFreshbooks
  def self.freshbooks_client
    FreshBooks::Client.new(Setting.plugin_redmine_freshbooks['freshbooks_domain'], User.current.freshbooks_api_key)
  end
end