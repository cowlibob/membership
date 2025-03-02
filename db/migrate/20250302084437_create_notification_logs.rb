class CreateNotificationLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_logs do |t|
      t.string :notification_type
      t.string :recipient
      t.string :subject
      t.timestamp :sent_at
      t.references :renewal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
