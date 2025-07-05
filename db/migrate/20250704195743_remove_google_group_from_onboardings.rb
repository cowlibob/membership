class RemoveGoogleGroupFromOnboardings < ActiveRecord::Migration[8.0]
  def change
    remove_column :onboardings, :google_group_attempted_at, :datetime
    remove_column :onboardings, :google_group_added_at, :datetime
  end
end
