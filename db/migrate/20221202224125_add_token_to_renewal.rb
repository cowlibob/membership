class AddTokenToRenewal < ActiveRecord::Migration[5.2]
  def change
    add_column :renewals, :token, :string
    add_column :renewals, :payemnt_id, :integer
    add_index :renewals, :token
  end
end
