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
  COLLECTION_ATTRIBUTES = %i[
  renewal
  id
  classname
  sail_number
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  renewal
  id
  classname
  sail_number
  hull_colour
  berthing
  name
  created_at
  updated_at
  is_sailboard
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  renewal
  classname
  sail_number
  hull_colour
  berthing
  name
  is_sailboard
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how boats are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(boat)
  #   "Boat ##{boat.id}"
  # end
end
