class AddRenewalIdToBoat < ActiveRecord::Migration
  def change
  	add_column :boats, :renewal_id, :integer
  end
end
