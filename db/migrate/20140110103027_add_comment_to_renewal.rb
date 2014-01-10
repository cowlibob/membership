class AddCommentToRenewal < ActiveRecord::Migration
  def change
  	add_column :renewals, :comment, :text
  end
end
