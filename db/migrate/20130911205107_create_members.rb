class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.date :dob

      t.timestamps
    end
  end
end
