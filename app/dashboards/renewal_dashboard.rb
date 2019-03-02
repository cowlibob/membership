require "administrate/base_dashboard"

class RenewalDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    primary_member: Field::HasOne.with_options(class_name: "::Member"),
    secondary_members: Field::HasMany.with_options(class_name: "::Member"),
    boats: Field::HasMany,
    duties: Field::HasMany,
    id: Field::Number,
    membership_class: Field::String,
    address_1: Field::String,
    address_2: Field::String,
    postcode: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    comment: Field::Text,
    reference: Field::String,
    payment_confirmed_at: Field::DateTime,
    insurance_confirmed: Field::Boolean,
    share_data_for_commission: Field::Boolean,
    declaration_confirmed: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :primary_member,
    :secondary_members,
    :boats,
    :duties,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :primary_member,
    :secondary_members,
    :boats,
    :duties,
    :id,
    :membership_class,
    :address_1,
    :address_2,
    :postcode,
    :created_at,
    :updated_at,
    :comment,
    :reference,
    :payment_confirmed_at,
    :insurance_confirmed,
    :share_data_for_commission,
    :declaration_confirmed,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :primary_member,
    :secondary_members,
    :boats,
    :duties,
    :membership_class,
    :address_1,
    :address_2,
    :postcode,
    :comment,
    :reference,
    :payment_confirmed_at,
    :insurance_confirmed,
    :share_data_for_commission,
    :declaration_confirmed,
  ].freeze

  # Overwrite this method to customize how renewals are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(renewal)
  #   "Renewal ##{renewal.id}"
  # end
end
