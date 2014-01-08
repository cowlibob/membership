ActiveAdmin.register Content do

  permit_params :tag, :content
  
  # controller do

  #   def create
  #     create! do |format|

  #       format.html do
  #         if request.ajax?
  #           render :text => "Complete"
  #         else
  #           active_admin_config.route_collection_path(params)
  #         end
  #       end

  #     end
  #   end

  #   def update
  #     update! do |format|

  #       format.html do
  #         if true
  #           render :text => "Complete"
  #         else
  #           active_admin_config.route_collection_path(params)
  #         end
  #       end

  #     end
  #   end

  # end

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
