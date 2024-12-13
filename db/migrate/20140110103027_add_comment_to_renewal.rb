class AddCommentToRenewal < ActiveRecord::Migration[5.2]
  def change
  	add_column :renewals, :comment, :text
  end
end
