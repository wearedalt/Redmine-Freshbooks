require_dependency 'principal'
require_dependency 'user'

module RedmineFreshbooks
  module UserPatch
    def self.included(base) # :nodoc:
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        # Same as typing in the class 
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          has_one :freshbooks_staff_member
          alias_method_chain :before_save, :assign_freshbooks_staff_member
          safe_attributes 'freshbooks_api_key', 'log_to_freshbooks'
        end

      end

      module ClassMethods

      end

      module InstanceMethods
        def before_save_with_assign_freshbooks_staff_member
          before_save_without_assign_freshbooks_staff_member

          #if the current user is saving changes on their record
          if User.current.name == self.name

            if self.freshbooks_api_key_changed? 
              unless self.freshbooks_api_key.nil? ||  self.freshbooks_api_key.empty?
                client = RedmineFreshbooks.freshbooks_client
                staff_hash =  client.staff.current['staff']
                staff = FreshbooksStaffMember.find_by_staff_id staff_hash['staff_id']

                if staff.nil?
                  staff_hash.delete 'code'
                  staff_hash.delete 'last_login'
                  staff_hash.delete 'signup_date'
                  staff_hash.delete 'number_of_logins'
                  staff = FreshbooksStaffMember.new staff_hash
                  staff.save
                end
                
                self.freshbooks_staff_member = staff
              end
            end
          end
        end
      end
  end
end
