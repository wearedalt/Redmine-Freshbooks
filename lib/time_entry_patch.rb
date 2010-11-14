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
          
          alias_method_chain :after_initialize, :set_send_to_freshbooks
        end

      end

      module ClassMethods

      end

      module InstanceMethods
        def after_initialize_with_set_send_to_freshbooks
          after_initialize_without_set_send_to_freshbooks
          @send_to_freshbooks = User.current.log_to_freshbooks
        end
      end
  end
end
