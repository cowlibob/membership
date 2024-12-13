class AddInsuranceConfirmedToRenewal < ActiveRecord::Migration[5.2]
  def change
    add_column :renewals, :insurance_confirmed, :boolean, default: false
    add_column :renewals, :share_data_for_commission, :boolean, default: false
    add_column :renewals, :declaration_confirmed, :boolean, default: false
  end
end
