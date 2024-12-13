class AddPaidFlagToRenewal < ActiveRecord::Migration[5.2]
  def change
  	add_column :renewals, :payment_confirmed_at, :timestamp
  end
end
