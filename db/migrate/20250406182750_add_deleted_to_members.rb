class AddDeletedToMembers < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :deleted, :boolean, default: false
  end
end
