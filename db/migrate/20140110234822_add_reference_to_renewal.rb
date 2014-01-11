class AddReferenceToRenewal < ActiveRecord::Migration
  def change
  	add_column :renewals, :reference, :string
  end
end
