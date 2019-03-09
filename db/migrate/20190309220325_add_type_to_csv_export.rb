class AddTypeToCsvExport < ActiveRecord::Migration[5.2]
  def change
  	add_column :csv_exports, :export_type, :string, default: 'renewal'
  end
end
