class Member < ActiveRecord::Base
	belongs_to :renewal, inverse_of: :primary_member, optional: true
  belongs_to :renewal, inverse_of: :secondary_members, optional: true



	scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
	
	def blank?
		[first_name, last_name, phone, email, dob].all?(&:blank?)
	end
	def full_name
		[first_name, last_name].join(" ")
	end

	def to_s
		full_name
	end

	def to_a
		[full_name, phone, email, dob]
	end

	def self.described
		all.map(&:described).join("; ")
	end

	def described
		date_of_birth = dob.present? ? "born #{dob}" : nil
		[full_name, date_of_birth, phone, email].join(', ')
	end

	def dob= value
		if value.is_a?(String)
			begin
				super Date.parse(value) 
			rescue => e
				errors.add(:dob, "is not a valid date")
			end
		else
			super value
		end
	end

end
