class AddPrimaryToMember < ActiveRecord::Migration[8.0]
  def change
    add_column :members, :primary, :boolean, default: false
  end
end
