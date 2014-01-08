class Content < ActiveRecord::Base
	def self.s(tag)
		Content.first(conditions: {tag: tag}).try(:content)
	end
end
