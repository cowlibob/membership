class Renewal < ActiveRecord::Base
  include SpreadsheetArchitect

  has_one :primary_member, lambda {
    where(primary: true)
  }, class_name: '::Member', dependent: :destroy, inverse_of: :renewal
  has_many :secondary_members, lambda {
    where(primary: false)
  }, class_name: '::Member', dependent: :destroy, inverse_of: :renewal
  has_many :boats, dependent: :destroy
  has_many :duties, dependent: :destroy
  # belongs_to :payment

  # validates :primary_member, :presence => true
  accepts_nested_attributes_for :primary_member, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :secondary_members, reject_if: :all_blank
  accepts_nested_attributes_for :boats, reject_if: :all_blank

  accepts_nested_attributes_for :duties, reject_if: :duty_not_populated

  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add attribute, (options[:message] || 'is not an email') unless
        /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.match?(value)
    end
  end
  validates :email, presence: true, email: true

  validate do
    boats.each do |boat|
      errors.add(:boats, '- All boats must be insured') unless boat.insured?
    end
  end

  scope :by_year, proc { |year| where(["DATE_PART('year', created_at) = ?", year]) }
  scope :ordered_by_year, proc { order("DATE_PART('year', created_at) DESC") }

  pay_customer default_payment_processor: :stripe, stripe_attributes: :stripe_attributes

  def includes_family?
    membership_class == 'family-membership'
  end

  def current_step
    valid? if errors.none?

    if primary_member.blank? || errors.attribute_names.include?(:email)
      :about_you
    elsif membership_class.blank?
      :membership_class
    elsif address.blank?
      :address
    elsif includes_family? && secondary_members.blank?
      :your_family
    elsif boats.blank? && !no_boats?
      :boats
    elsif emergency_contact_details.blank?
      :emergency_contact
    # elsif duties.blank?
    # 	:duties
    elsif !declaration_confirmed?
      :declaration
    elsif !is_paid?
      :payment
    else
      :complete
    end
  end

  def complete?
    current_step == :complete
  end

  def address
    [address_1, address_2, postcode].join
  end

  def generate_token!
    self.token ||= SecureRandom.uuid
  end

  def spreadsheet_columns
    [
      ['Renewal ID', id],
      ['Payment Reference', reference],
      ['Total Cost', total_cost],
      ['Membership Class', membership_class],
      ['Membership Cost', membership_cost],
      ['Berthing Costs', berthing_cost],
      ['100 Club Ticket Costs', one_hundred_club_cost],
      ['Address', [address_1, address_2, postcode].compact.join(', ')],
      ['Primary Member', primary_member&.described],
      ['Secondary Members', secondary_members&.described],
      ['Boats', boats.described],
      # ['Duties', duties.described],
      ['Comment', comment]
    ]
  end

  def line_item_rows
    [
      [membership_class_name + ' Membership', membership_cost],
      ["Berthed Boats x #{boats.is_dinghy.where(berthing: true).count}", boat_berthing_cost],
      ["Berthed Sailboards x #{boats.is_sailboard.where(berthing: true).count}", sailboard_berthing_cost]
      # ["100 Club Ticket x #{one_hundred_club_tickets}", one_hundred_club_cost]
    ]
  end

  def membership_class_name
    Renewal.membership_classes[membership_class].try(:[], :title)
    # values = Renewal.membership_classes.select{|k, v| v[:ui_id] == membership_class}.values.first
    # values[:title]
  end

  def line_item_total
    ['Total', total_cost]
  end

  def duty_invite_columns
    [
      ['Email', primary_member&.email],
      ['Names', secondary_members&.map { |m| m.full_name }&.join(';')]
    ]
  end

  def all_members
    secondary_members
  end

  def all_display_name_emails
    all_members.map do |member|
      "#{member.full_name} <#{member.email}>"
    end
  end

  def duty_not_populated(duty)
    duty['exclude'].blank? and duty['request'].blank?
  end

  after_create :generate_reference

  def excluded_dates=(val)
    excluded = val.split(',')
    excluded.each_slice(3) do |dates|
      new_duty(dates, 'exclude')
    end
  end

  def preferred_dates=(val)
    preferred = val.split(',')
    preferred.each_slice(3) do |dates|
      new_duty(dates, 'request')
    end
  end

  def new_duty(dates, preference)
    duties.build(
      preference: preference,
      thursday: Date.parse(dates[0]),
      saturday: Date.parse(dates[1]),
      sunday: Date.parse(dates[2])
    )
  end

  def mark_as_paid!
    write_attribute(:payment_confirmed_at, Time.now.localtime)
    save
  end

  def is_paid?
    charges.select { |charge| charge.captured? }.any?
  end

  def generate_reference
    return unless primary_member && reference.blank?

    update(reference: "#{primary_member.email[0..8]}-#{id}".gsub(/[@.-]/, ''))
  end

  def to_param
    reference
  end

  def self.membership_classes
    {
      'full-membership' => {
        title: 'Single Adult',
        description: 'Full membership for one adult',
        feature_1: 'Full use of facilities and club boats',
        feature_2: 'Free safety boat training',
        ui_class: 'full',
        ui_id: 'full-membership',
        name: 'Full',
        cost: 190
      },
      'family-membership' => {
        title: 'Family',
        description: 'Principal member with partner and dependents still in full time education or on an apprenticeship scheme.',
        # description: 'One adult, a partner and children in full-time education or apprenticeship',
        feature_1: 'Full use of facilities and club boats',
        feature_2: 'Free safety boat training',
        ui_class: 'family',
        ui_id: 'family-membership',
        name: 'Full',
        cost: 190
      },
      'youth-membership' => {
        title: 'Youth',
        description: 'One person over 12 and in full-time education or apprenticeship',
        feature_1: 'Full use of facilities and club boats',
        feature_2: 'Free safety boat training',
        ui_class: '',
        ui_id: 'youth-membership',
        name: 'Youth',
        cost: 60
      },
      'retained-membership' => {
        title: 'Retained',
        description: 'One Adult',
        feature_1: 'Retain link with the club while away or unable to sail',
        feature_2: '',
        ui_class: '',
        ui_id: 'retained-membership',
        name: 'Retained',
        cost: 30
      },
      'honorary-membership' => {
        title: 'Honourary',
        description: 'One adult, by invitation only!',
        feature_1: 'Full use of facilities and club boats',
        feature_2: 'Free safety boat training',
        ui_class: '',
        ui_id: 'honorary-membership',
        name: 'Honorary',
        cost: 0
      }
    }

    # 'Full or Familiy Membership (includes partner and children under 18)', 'Full'],
    # ['Cadet Membership (18 years and above in full-time education)', 'Cadet'],
    # ['Retained Member (non-active sailor)', 'Retained'],
    # ['Honorary Member', 'Honorary']
  end

  def self.membership_costs(membership_class)
    membership_classes[membership_class].try(:[], :cost)
  end

  def self.berthing_costs
    { boat: 50, sailboard: 20 }
  end

  def self.one_hundred_ticket_costs
    25
  end

  def membership_cost
    Renewal.membership_costs(membership_class) || 0
  end

  def berthing_cost
    boat_berthing_cost + sailboard_berthing_cost
  end

  def boat_berthing_cost
    boats.is_dinghy.where(berthing: true).count * Renewal.berthing_costs[:boat]
  end

  def sailboard_berthing_cost
    boats.is_sailboard.where(berthing: true).count * Renewal.berthing_costs[:sailboard]
  end

  def one_hundred_club_cost
    one_hundred_club_tickets * Renewal.one_hundred_ticket_costs
  end

  def total_cost
    membership_cost + berthing_cost + one_hundred_club_cost
  end

  def self.recent
    where(created_at: 1.week.ago..Time.now)
  end

  def to_s
    "#{primary_member.try :full_name} (#{membership_class} #{created_at.year})"
  end

  def secondary_member_count
    secondary_members.count
  end

  def boat_count
    boats.count
  end

  def year
    created_at.year
  end

  def stripe_attributes(pay_customer)
    {
      address: {
        line1: address_1,
        line2: address_2,
        postal_code: postcode
      },
      metadata: {
        reference: reference,
        membership_class: membership_class,
        boat_count: boats.is_dinghy.where(berthing: true).count,
        sailboard_count: boats.is_sailboard.where(berthing: true).count
      },
      email: primary_member&.email
    }
  end

  def email
    primary_member&.email
  end
end
