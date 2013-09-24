class Renewal < ActiveRecord::Base

	has_one :primary_member, :class_name => '::Member'
	has_many :secondary_members, :class_name => '::Member'


	def membership_classes
		[
			['Full or Familiy Membership (includes partner and children under 18)', 'Full'],
			['Cadet Membership (18 years and above in full-time education)', 'Cadet'],
			['Retained Member (non-active sailor)', 'Retained'],
			['Honorary Member', 'Honorary']
		]
	end

	def primary_member
		super || Member.new(renewal: self)
	end

	def secondary_members
		super || [Member.new(renewal: self)]
	end
end
