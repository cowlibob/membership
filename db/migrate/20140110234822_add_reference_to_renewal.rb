class AddReferenceToRenewal < ActiveRecord::Migration[5.2]
  def change
  	add_column :renewals, :reference, :string
  end
end
