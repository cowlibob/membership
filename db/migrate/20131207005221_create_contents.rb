class CreateContents < ActiveRecord::Migration[5.2]
  def change
    create_table :contents do |t|
      t.string :tag
      t.text :content

      t.timestamps
    end
    add_index :contents, :tag, unique: true
  end
end
