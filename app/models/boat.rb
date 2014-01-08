class Boat < ActiveRecord::Base
	belongs_to :renewal
	
	def to_s
		"#{classname} #{sail_number}"
	end
end
