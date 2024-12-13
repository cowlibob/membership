class CreateDuties < ActiveRecord::Migration[5.2]
  def up
    create_table :duties do |t|
      t.integer :renewal_id
      t.date :thursday
      t.date :saturday
      t.date :sunday

      t.timestamps
    end
  end

  def down
  	drop_table :duties
  end
end
