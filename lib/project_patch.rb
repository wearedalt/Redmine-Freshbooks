require_dependency 'project'

module RedmineFreshbooks
  module ProjectPatch
    def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        # Same as typing in the class 
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          belongs_to :freshbooks_project

        end

      end

      module ClassMethods

      end

      module InstanceMethods
      end
  end
end
