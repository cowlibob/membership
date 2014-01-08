ActiveAdmin.register Renewal do

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  menu :priority => 1
  index do
    selectable_column
    column :reference, :sortable => false
    column "Member Name", :primary_member
    column :membership_class
    column "Family Members", :secondary_member_count
    column "Boats", :boat_count
  end

  csv do
    column :reference
    column("Member Name") {|renewal| renewal.primary_member}
    column :membership_class
    column("Family Members") {|renewal| renewal.secondary_member_count}
    column("Boats") {|renewal| renewal.boat_count}
  end
  
end
