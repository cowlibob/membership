ActiveAdmin.register Renewal do

  controller do
    defaults :finder => :find_by_reference
  end

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

  permit_params :payment_confirmed_at

  member_action :mark_as_paid, :method => :put do
    renewal = Renewal.find_by_reference(params[:id])
    renewal.mark_as_paid!
    redirect_to :action => :index
  end

  menu :priority => 1
  index do
    selectable_column
    column("Reference") {|renewal| link_to renewal.reference, renewal_path(renewal)}
    column "Member Name", :primary_member
    column :membership_class
    column("Family Members") {|renewal| renewal.secondary_members.all.collect{|member| member.full_name}.join(', ') }
    column("Boats") {|renewal| renewal.boats.collect{|boat| "#{boat.classname} #{boat.sail_number}"}.join(', ') }
    column("Fee") {|renewal| "£#{renewal.membership_cost}"}
    column("Berthing") {|renewal| "£#{renewal.berthing_cost}"}
    column("Cost") {|renewal| "£#{renewal.total_cost}"}
    column("Paid") {|renewal| renewal.payment_confirmed_at || link_to('Mark as Paid', mark_as_paid_admin_renewal_path(renewal), :method => :put)}
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :membership_class
      f.input :address_1
      f.input :address_2
      f.input :postcode
      f.input :comment
      f.input :reference
      f.input :payment_confirmed_at
    end
    f.actions
  end    

  csv do
    column :reference
    column("Member Name") {|renewal| renewal.primary_member}
    column :membership_class
    column("Family Members") {|renewal| renewal.secondary_members.all.collect{|member| member.full_name}.join(', ') }
    column("Boats") {|renewal| renewal.boats.collect{|boat| "#{boat.classname} #{boat.sail_number}"}.join(', ') }
    column :membership_cost
    column :berthing_cost
    column :total_cost
    column :payment_confirmed_at
  end
  
end
