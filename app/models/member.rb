class Member < ActiveRecord::Base
	belongs_to :renewal

	scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
	
	def full_name
		[first_name, last_name].join(" ")
	end

	def to_s
		full_name
	end

end
