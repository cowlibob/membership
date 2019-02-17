class Boat < ActiveRecord::Base
	belongs_to :renewal

	scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
	
	def self.is_dinghy
		where(is_sailboard: false)
	end

	def self.is_sailboard
		where(is_sailboard: true)
	end
	
	def to_s
		"#{classname} #{sail_number}"
	end
end
