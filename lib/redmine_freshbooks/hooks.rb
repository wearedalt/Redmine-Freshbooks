class Hooks < Redmine::Hook::ViewListener
  def controller_timelog_edit_before_save(context={ })
      Rails.logger.debug "DEBUG"
      entry = context[:time_entry]
       if entry.issue_id?
       related_issue = Issue.find entry.issue_id
       Rails.logger.debug "Spent on: " + entry.spent_on.to_s
       Rails.logger.debug "Hours: " + entry.hours.to_s
       Rails.logger.debug "Comments: " + entry.comments.to_s
       Rails.logger.debug "Issue Id: " + entry.issue_id.to_s
       
       Rails.logger.debug "Activity Id: " + entry.activity_id.to_s
       
       
         
       
         Rails.logger.debug "Issue: " + related_issue.subject
       end
       
       Rails.logger.debug "DONE"
    end
    render_on :view_my_account,
      :partial => 'account_form'
      
    render_on :view_projects_form,
      :partial => 'project_settings'
end