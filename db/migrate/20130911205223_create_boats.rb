class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      t.string :classname
      t.string :sail_number
      t.string :hull_colour
      t.boolean :berthing
      t.string :name

      t.timestamps
    end
  end
end
