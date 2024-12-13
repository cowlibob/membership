class AddIsSailboardToBoats < ActiveRecord::Migration[5.2]
  def change
  	add_column :boats, :is_sailboard, :boolean, default: false, nil: false
  end
end
