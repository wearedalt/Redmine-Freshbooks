class Hooks < Redmine::Hook::ViewListener
  
    
    render_on :view_my_account,
      :partial => 'account_form'
    render_on :view_timelog_edit_form_bottom,
      :partial => 'timelog_form'
    render_on :view_projects_form,
      :partial => 'project_settings'
end