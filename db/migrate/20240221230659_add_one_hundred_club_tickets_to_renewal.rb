class AddOneHundredClubTicketsToRenewal < ActiveRecord::Migration[5.2]
  def change
    add_column :renewals, :one_hundred_club_tickets, :integer, default: 0, nil: false
  end
end
