class AddDeletedToRenewals < ActiveRecord::Migration[8.0]
  def change
    add_column :renewals, :deleted, :boolean, default: false
  end
end
