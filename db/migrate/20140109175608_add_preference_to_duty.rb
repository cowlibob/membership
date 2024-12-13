class AddPreferenceToDuty < ActiveRecord::Migration[5.2]
  def change
  	add_column :duties, :preference, :string, :default => 'request'
  end
end
