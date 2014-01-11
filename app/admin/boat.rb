ActiveAdmin.register Boat do

  
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
  
  csv do
    column("Member Name") {|boat| boat.renewal.primary_member}
    column :classname
    column :sail_number
    column :hull_colour
    column :berthing
    column :name
  end

end
