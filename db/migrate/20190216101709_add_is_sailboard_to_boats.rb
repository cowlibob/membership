class AddIsSailboardToBoats < ActiveRecord::Migration
  def change
  	add_column :boats, :is_sailboard, :boolean, default: false, nil: false
  end
end
