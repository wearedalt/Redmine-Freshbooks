class FreshbooksController < ApplicationController
  unloadable

  def sync
    @client = RedmineFreshbooks.freshbooks_client
    import_staff
    import_projects
    sync_tasks_and_activities
    flash[:notice] = "Sync successful"
    redirect_to :controller => 'settings', :action => 'plugin', :id => 'redmine_freshbooks'
  end
  
  private
  
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
          fb_project.projects.each do |project|

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
    
    def import_staff
      staff = @client.staff.list['staff_members']['member']
      if staff.kind_of? Array
        staff.each {|hash| add_staff_from_hash(hash) }
      else
        add_staff_from_hash(staff)
      end
    end
    
    def import_projects
      curr_page = 0
      pages = 1

      while curr_page != pages
        projects_set = @client.project.list(:page => curr_page+1, :per_page => 100)['projects']
        pages = projects_set['pages'].to_i
        curr_page = projects_set['page'].to_i

        projects = projects_set['project']

        if projects.kind_of? Array
          projects.each do |project_hash|
            add_project_from_hash project_hash
          end
        else
          add_project_from_hash projects
        end
      end
    end
    
    def import_tasks(project)
      curr_page = 0
      pages = 1

      while curr_page != pages
        if(project)
          tasks_set = @client.task.list(:page => curr_page+1, :per_page => 100, :project_id => project.project_id)['tasks']
        else
          tasks_set = @client.task.list(:page => curr_page+1, :per_page => 100)['tasks']
        end
        pages = tasks_set['pages'].to_i
        curr_page = tasks_set['page'].to_i

        tasks = tasks_set['task']

        if tasks.kind_of? Array
          tasks.each do |task_hash|
            add_task_from_hash task_hash, project
          end
        else
          add_task_from_hash tasks, project
        end
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
    
    def add_staff_from_hash(staff_hash)
      staff_hash.delete 'code'
      staff_hash.delete 'last_login'
      staff_hash.delete 'signup_date'
      staff_hash.delete 'number_of_logins'
      staff = FreshbooksStaffMember.find_by_staff_id staff_hash['staff_id']
      
      if staff == nil
        staff = FreshbooksStaffMember.new staff_hash
        staff.save
      else
        staff.update_attributes staff_hash
      end
    end
    
    
    def add_project_from_hash(project_hash)
      project_hash['freshbooks_staff_members'] = []
      if project_hash['staff']['staff_id'].kind_of? Array
        project_hash['staff']['staff_id'].each do |member_id|
          staff_mem = FreshbooksStaffMember.find_by_staff_id member_id
          project_hash['freshbooks_staff_members'].push staff_mem
        end
      else
        staff_mem = FreshbooksStaffMember.find_by_staff_id project_hash['staff']['staff_id']
        project_hash['freshbooks_staff_members'].push staff_mem
      end
      project_hash.delete 'staff'
      
      # TODO: dirty : should store budget as well
      project_hash.delete 'budget'
      
      # TODO: dirty : they added the 'tasks' key, which should simplify the tasks import but here it makes the sync fail
      project_hash.delete 'tasks'
      
      # TODO: dirty : unknown attribute error
      project_hash.delete 'project_manager_id'

      proj = FreshbooksProject.find_by_project_id project_hash['project_id']
      
      if proj == nil
        proj = FreshbooksProject.new project_hash
        proj.save!
      else
        proj.update_attributes project_hash
      end
      proj.freshbooks_tasks.clear
      import_tasks(proj)
      
    end
    
end
