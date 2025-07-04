class AddErrorMessageToOnboardings < ActiveRecord::Migration[8.0]
  def change
    add_column :onboardings, :error_message, :text
  end
end
