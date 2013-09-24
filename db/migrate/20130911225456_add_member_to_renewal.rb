class AddMemberToRenewal < ActiveRecord::Migration
  def change
  	add_column :members, :renewal_id, :integer
  end
end
