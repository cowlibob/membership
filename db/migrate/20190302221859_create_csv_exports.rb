class CreateCsvExports < ActiveRecord::Migration[5.2]
  def change
    create_table :csv_exports do |t|
      t.integer :year
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
