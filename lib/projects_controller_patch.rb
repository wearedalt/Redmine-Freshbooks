require_dependency 'projects_controller'

module RedmineFreshbooks
  module ProjectsControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, FreshbooksMethods)

      base.class_eval do
        unloadable
        alias_method_chain :settings, :freshbooks_projects
      end
    end
  
    module FreshbooksMethods
      # sets @freshbooks_projects to the list of freshbooks projects available to the user
      def settings_with_freshbooks_projects
        settings_without_freshbooks_projects
        Rails.logger.debug @project.freshbooks_project_id
        client = RedmineFreshbooks.freshbooks_client
        @freshbooks_projects = client.project.list['projects']['project']
      end
    
    
    
    end
  end
end
