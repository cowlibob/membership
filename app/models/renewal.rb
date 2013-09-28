class Renewal < ActiveRecord::Base

	has_one :primary_member, :class_name => '::Member'
	has_many :secondary_members, :class_name => '::Member'

	accepts_nested_attributes_for :primary_member
	accepts_nested_attributes_for :secondary_members

	def reference
		"#{self.primary_member.email[0..8]}-#{self.id}" if self.primary_member
	end

	def membership_classes
		[
			['Full or Familiy Membership (includes partner and children under 18)', 'Full'],
			['Cadet Membership (18 years and above in full-time education)', 'Cadet'],
			['Retained Member (non-active sailor)', 'Retained'],
			['Honorary Member', 'Honorary']
		]
	end

	def membership_cost
		{'Full' => 140, 'Cadet' => 58, 'Retained' => 26, 'Honorary' => 0}[self.membership_class]
	end

	def total_cost
		membership_cost
	end



end
