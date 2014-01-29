class AddPaidFlagToRenewal < ActiveRecord::Migration
  def change
  	add_column :renewals, :payment_confirmed_at, :timestamp
  end
end
