#require_dependency 'project'

module RedmineFreshbooks
  module ProjectPatch
    def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        # Same as typing in the class 
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          belongs_to :freshbooks_project
          after_update :sync_freshbooks_project
          safe_attributes 'freshbooks_project_id'
        end

      end

      module ClassMethods

      end

      module InstanceMethods
        def sync_freshbooks_project
          @client = RedmineFreshbooks.freshbooks_client
          if(self.freshbooks_project)
            curr_page = 0
            pages = 1

            while curr_page != pages
              if(project)
                tasks_set = @client.task.list(:page => curr_page+1, :per_page => 100, :project_id => self.freshbooks_project.project_id)['tasks']
              else
                tasks_set = @client.task.list(:page => curr_page+1, :per_page => 100)['tasks']
              end
              pages = tasks_set['pages'].to_i
              curr_page = tasks_set['page'].to_i

              tasks = tasks_set['task']

              if tasks.kind_of? Array
                tasks.each do |task_hash|
                  add_task_from_hash task_hash, self.freshbooks_project
                end
              else
                add_task_from_hash tasks, self.freshbooks_project
              end
            end
            sync_tasks_and_activities
          end
        end
        def add_task_from_hash(task_hash, project)
          task = FreshbooksTask.find_by_task_id task_hash['task_id']

          if task == nil
            task = FreshbooksTask.new task_hash
            task.save
          else
            task.update_attributes task_hash
          end

          unless project.freshbooks_tasks.include? task
            project.freshbooks_tasks<< task
          end
        end
        def sync_tasks_and_activities
          tasks = FreshbooksTask.all
          activities = Enumeration.all(:conditions => "project_id is not null and type = 'TimeEntryActivity'")
          activities.each do |activity|
            activity.active = false
            activity.save
          end
          max_position = Enumeration.find_by_type('TimeEntryActivity', :order => 'position').position
          tasks.each do |task|
            task.freshbooks_projects.each do |fb_project|
              if fb_project.project
                project = fb_project.project

                act = Enumeration.find_by_type_and_name_and_project_id 'TimeEntryActivity', task.name, project.id

                unless act
                  max_position += 1
                  act = Enumeration.new
                  act.position = max_position
                  act.type = 'TimeEntryActivity'
                  act.name = task.name
                  act.project_id = project.id
                end
                act.active = true
                act.save!
              end
            end
          end

        end
      end
  end
end
