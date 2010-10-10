class FreshbooksController < ApplicationController
  unloadable

  def sync
    client = RedmineFreshbooks.freshbooks_client
    curr_page = 0
    pages = 1

    while curr_page != pages
      projects_set = client.project.list(:page => curr_page+1, :per_page => 3)['projects']
      pages = projects_set['pages'].to_i
      curr_page = projects_set['page'].to_i

      projects = projects_set['project']
      
      if projects.kind_of? Array
        projects.each do |project_hash|
          Rails.logger.debug project_hash
          add_project_from_hash project_hash
        end
      end
      
      if projects.kind_of? Hash
        add_project_from_hash projects
      end
    end
  
    flash[:notice] = "Sync successful"
    redirect_to :controller => 'settings', :action => 'plugin', :id => 'redmine_freshbooks'
  end
  
  private
    def add_project_from_hash(project_hash)
      project_hash.delete 'staff'
      proj = FreshbooksProject.find_by_project_id project_hash['project_id'].to_i
      if proj == nil
        proj = FreshbooksProject.new project_hash
        proj.save
      end
    end
end
