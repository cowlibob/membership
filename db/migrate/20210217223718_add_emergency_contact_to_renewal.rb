class AddEmergencyContactToRenewal < ActiveRecord::Migration[5.2]
  def change
    add_column :renewals, :emergency_contact_details, :text
  end
end
