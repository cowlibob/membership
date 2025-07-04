class CreateOnboardings < ActiveRecord::Migration[8.0]
  def change
    create_table :onboardings do |t|
      t.references :member, null: false, foreign_key: true
      t.datetime :google_group_attempted_at
      t.datetime :google_group_added_at
      t.datetime :website_attempted_at
      t.datetime :website_added_at
      t.datetime :whatsapp_invite_email_sent_at
      t.datetime :management_email_sent_at

      t.timestamps
    end
  end
end
