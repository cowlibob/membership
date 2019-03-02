require "administrate/base_dashboard"

class BoatDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    renewal: Field::BelongsTo,
    id: Field::Number,
    classname: Field::String,
    sail_number: Field::String,
    hull_colour: Field::String,
    berthing: Field::Boolean,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    is_sailboard: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :renewal,
    :id,
    :classname,
    :sail_number,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :renewal,
    :id,
    :classname,
    :sail_number,
    :hull_colour,
    :berthing,
    :name,
    :created_at,
    :updated_at,
    :is_sailboard,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :renewal,
    :classname,
    :sail_number,
    :hull_colour,
    :berthing,
    :name,
    :is_sailboard,
  ].freeze

  # Overwrite this method to customize how boats are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(boat)
  #   "Boat ##{boat.id}"
  # end
end
