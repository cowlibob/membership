class AddMemberToRenewal < ActiveRecord::Migration[5.2]
  def change
  	add_column :members, :renewal_id, :integer
  end
end
