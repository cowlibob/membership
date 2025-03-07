class AddInsuredToBoat < ActiveRecord::Migration[8.0]
  def change
    add_column :boats, :insured, :boolean
  end
end
