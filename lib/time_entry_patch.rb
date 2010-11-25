require_dependency 'time_entry'

module RedmineFreshbooks
  module TimeEntryPatch
    def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        # Same as typing in the class 
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          attr_accessor :send_to_freshbooks, :freshbooks_project_permitted, :is_editing
          after_create :send_new_entry_to_freshbooks
          after_update :update_freshbooks_time_entry
          alias_method_chain :after_initialize, :set_send_to_freshbooks
        end

      end

      module ClassMethods

      end

      module InstanceMethods
        def after_initialize_with_set_send_to_freshbooks
          @send_to_freshbooks = false
          @freshbooks_project_permitted = false

          unless User.current.freshbooks_api_key.nil? || User.current.freshbooks_api_key.empty?

            if @project
              @freshbooks_project_permitted = @project.freshbooks_project.freshbooks_staff_members.include?(User.current.freshbooks_staff_member)
              @send_to_freshbooks = User.current.log_to_freshbooks && @freshbooks_project_permitted
            end
          end
          after_initialize_without_set_send_to_freshbooks
          
        end
        
        def send_new_entry_to_freshbooks
          if @send_to_freshbooks == true
              create_freshbooks_time_entry
           end
        end
        
        def create_freshbooks_time_entry
          new_time_entry_hash = {}
          new_time_entry_hash[:date] = self.spent_on.strftime('%Y-%m-%d')
          new_time_entry_hash[:hours] = self.hours
          related_issue = Issue.find self.issue_id
          activity = Enumeration.find self.activity_id
          task = FreshbooksTask.find_by_name activity.name
          new_time_entry_hash[:project_id] = related_issue.project.freshbooks_project.project_id
          new_time_entry_hash[:notes] = "Issue #" + self.issue_id.to_s + ": " + self.comments
          new_time_entry_hash[:task_id] = task.task_id

          client = RedmineFreshbooks.freshbooks_client
          response = client.time_entry.create :time_entry => new_time_entry_hash
          @freshbooks_edit = true
          self.freshbooks_time_entry_id = response['time_entry_id']
          self.save!
        end
        
        
        def update_freshbooks_time_entry
          if @send_to_freshbooks == true
            unless @freshbooks_edit && !self.changed?
              
              if self.freshbooks_time_entry_id
                new_time_entry_hash = {}
                new_time_entry_hash[:time_entry_id] = self.freshbooks_time_entry_id
                if self.hours_changed?
                  new_time_entry_hash[:hours] = self.hours
                end
                if self.spent_on_changed?
                  new_time_entry_hash[:date] = self.spent_on.strftime('%Y-%m-%d')
                end
                if self.issue_id_changed? || self.comments_changed?
                  new_time_entry_hash[:notes] = "Issue #" + self.issue_id.to_s + ": " + self.comments
                end
                if self.activity_id_changed?
                  activity = Enumeration.find self.activity_id
                  task = FreshbooksTask.find_by_name activity.name
                  new_time_entry_hash[:task_id] = task.task_id
                end

                client = RedmineFreshbooks.freshbooks_client
                response = client.time_entry.update :time_entry => new_time_entry_hash
              else
                create_freshbooks_time_entry
              end
            end

           end
        end
        
      end
  end
end
