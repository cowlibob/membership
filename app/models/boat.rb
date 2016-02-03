class Boat < ActiveRecord::Base
	belongs_to :renewal

	scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
	
	def to_s
		"#{classname} #{sail_number}"
	end
end
