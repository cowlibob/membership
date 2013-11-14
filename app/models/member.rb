class Member < ActiveRecord::Base
	belongs_to :renewal

	def full_name
		[first_name, last_name].join(" ")
	end

end
