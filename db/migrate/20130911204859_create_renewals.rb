class CreateRenewals < ActiveRecord::Migration
  def change
    create_table :renewals do |t|
      t.string :membership_class
      t.string :address_1
      t.string :address_2
      t.string :postcode

      t.timestamps
    end
  end
end
