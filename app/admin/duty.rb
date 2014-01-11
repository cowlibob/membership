ActiveAdmin.register Duty do

  
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
  
  index do
    selectable_column
    column("reference") {|duty| duty.renewal.reference}
    column("Member Name") {|duty| duty.renewal.primary_member}
    column :preference
    column :thursday
    column :saturday
    column :sunday
    default_actions
  end

  csv do
    column("reference") {|duty| duty.renewal.reference}
    column("Member Name") {|duty| duty.renewal.primary_member}
    column :preference
    column :thursday
    column :saturday
    column :sunday
  end

end
