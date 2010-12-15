class Hooks < Redmine::Hook::ViewListener
    def controller_timelog_edit_before_save(context={ })
      if(Setting["plugin_redmine_freshbooks"]['freshbooks_enabled'] == 'yes') 
       context[:time_entry].send_to_freshbooks = false
       context[:time_entry].freshbooks_project_permitted = false
       context[:time_entry].is_editing = true
       project = Project.find context[:time_entry].project_id
       unless User.current.freshbooks_api_key.nil? || User.current.freshbooks_api_key.empty?
         if project
           context[:time_entry].freshbooks_project_permitted = project.freshbooks_project.freshbooks_staff_members.include?(User.current.freshbooks_staff_member)
           context[:time_entry].send_to_freshbooks = User.current.log_to_freshbooks && context[:time_entry].freshbooks_project_permitted
         end
       end
     end
    end
    
    
    render_on :view_my_account,
      :partial => 'account_form'
    render_on :view_timelog_edit_form_bottom,
      :partial => 'timelog_form'
    render_on :view_projects_form,
      :partial => 'project_settings'
end