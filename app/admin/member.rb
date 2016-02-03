ActiveAdmin.register Member do
  (Date.today.year-3..Date.today.year).to_a.reverse.each {|year| scope(year.to_s) { |scope| scope.by_year(year)} }


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

end
