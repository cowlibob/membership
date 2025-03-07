class Boat < ActiveRecord::Base
  belongs_to :renewal

  scope :by_year, proc { |year| where(["DATE_PART('year', created_at) = ?", year]) }

  def self.berthed
    where(berthing: true)
  end

  def self.is_dinghy
    where(is_sailboard: [nil, false])
  end

  def self.is_sailboard
    where(is_sailboard: true)
  end

  def to_s
    "#{classname} #{sail_number}"
  end

  def self.described
    all.map(&:described).join('; ')
  end

  def described
    named = name.blank? ? nil : "(named #{name})"
    sailboard = is_sailboard ? ', a sailboard' : nil
    berthed = berthing ? 'with berth' : 'no berth'

    [
      hull_colour,
      classname,
      sail_number,
      named,
      sailboard,
      berthed
    ].compact.join(' ')
  end
end
