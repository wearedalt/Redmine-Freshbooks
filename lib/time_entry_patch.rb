require_dependency 'time_entry'

module RedmineFreshbooks
  module TimeEntryPatch
    def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        # Same as typing in the class 
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          attr_accessor :send_to_freshbooks
          attr_accessor :freshbooks_project_permitted
          
          alias_method_chain :after_initialize, :set_send_to_freshbooks
        end

      end

      module ClassMethods

      end

      module InstanceMethods
        def after_initialize_with_set_send_to_freshbooks
          after_initialize_without_set_send_to_freshbooks
          if @project
            @freshbooks_project_permitted = @project.freshbooks_project.freshbooks_staff_members.include?(User.current.freshbooks_staff_member)
            Rails.logger.debug "Allowed = " + @freshbooks_project_permitted.to_s
            @send_to_freshbooks = User.current.log_to_freshbooks && @freshbooks_project_permitted
          end
        end
      end
  end
end
