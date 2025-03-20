class Member < ActiveRecord::Base
  include SpreadsheetArchitect

  belongs_to :renewal, inverse_of: :primary_member, optional: true
  belongs_to :renewal, inverse_of: :secondary_members, optional: true

  scope :by_year, proc { |year| where(["DATE_PART('year', created_at) = ?", year]) }

  def spreadsheet_columns
    [
      ['Name', :full_name],
      ['First Name', :first_name],
      ['Last Name', :last_name],
      ['Phone', :phone],
      ['Email', :email],
      ['Date of Birth', :dob],
      ['Primary Member?', :primary?],
      ['Renewal', renewal.reference],
      ['Created At', created_at],
      ['Updated At', updated_at]
    ]
  end

  def blank?
    [first_name, last_name, phone, email, dob].all?(&:blank?)
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def to_s
    full_name
  end

  def to_a
    [full_name, phone, email, dob]
  end

  def self.described
    all.map(&:described).join('; ')
  end

  def described
    date_of_birth = dob.present? ? "born #{dob}" : nil
    [full_name, date_of_birth, phone, email].join(', ')
  end

  def dob=(value)
    if value.is_a?(String)
      begin
        super Date.parse(value)
      rescue StandardError => e
        errors.add(:dob, 'is not a valid date')
      end
    else
      super value
    end
  end
end
