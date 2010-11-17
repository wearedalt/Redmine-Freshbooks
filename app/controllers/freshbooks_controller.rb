class FreshbooksController < ApplicationController
  unloadable

  def sync
    @client = RedmineFreshbooks.freshbooks_client
    import_tasks
    import_staff
    import_projects
    
    flash[:notice] = "Sync successful"
    redirect_to :controller => 'settings', :action => 'plugin', :id => 'redmine_freshbooks'
  end
  
  private
  
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
        projects_set = @client.project.list(:page => curr_page+1, :per_page => 15)['projects']
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
    
    def import_tasks
      curr_page = 0
      pages = 1

      while curr_page != pages
        tasks_set = @client.task.list(:page => curr_page+1, :per_page => 15)['tasks']
        pages = tasks_set['pages'].to_i
        curr_page = tasks_set['page'].to_i

        tasks = tasks_set['task']

        if tasks.kind_of? Array
          tasks.each do |task_hash|
            add_task_from_hash task_hash
          end
        else
          add_task_from_hash tasks
        end
      end
    end
    
    
    
    def add_task_from_hash(task_hash)
      task = FreshbooksTask.find_by_task_id task_hash['task_id']
      
      if task == nil
        task = FreshbooksTask.new task_hash
        task.save
      else
        task.update_attributes task_hash
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
      
      if project_hash['staff'].kind_of? Array
        project_hash['staff'].each do |member_id|
          staff_mem = FreshbooksStaffMember.find_by_staff_id member_id['staff_id']
          project_hash['freshbooks_staff_members'].push staff_mem
        end
      else
        staff_mem = FreshbooksStaffMember.find_by_staff_id project_hash['staff']['staff_id']
        project_hash['freshbooks_staff_members'].push staff_mem
      end
      project_hash.delete 'staff'
      proj = FreshbooksProject.find_by_project_id project_hash['project_id']
      if proj == nil
        proj = FreshbooksProject.new project_hash
        proj.save
      else
        proj.update_attributes project_hash
      end
      project_hash['freshbooks_staff_members'].each do |member|
        proj.freshbooks_staff_members.push member
      end
      
      proj.save
      
    end
    
end
