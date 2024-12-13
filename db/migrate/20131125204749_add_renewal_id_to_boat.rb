class AddRenewalIdToBoat < ActiveRecord::Migration[5.2]
  def change
  	add_column :boats, :renewal_id, :integer
  end
end
