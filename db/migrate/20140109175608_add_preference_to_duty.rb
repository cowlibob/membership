class AddPreferenceToDuty < ActiveRecord::Migration
  def change
  	add_column :duties, :preference, :string, :default => 'request'
  end
end
