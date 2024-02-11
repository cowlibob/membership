class Renewal < ActiveRecord::Base

	include SpreadsheetArchitect

	has_one :primary_member, :class_name => '::Member', :dependent => :destroy
	has_many :secondary_members, :class_name => '::Member', :dependent => :destroy
	has_many :boats, :dependent => :destroy
	has_many :duties, :dependent => :destroy

	validates :primary_member, :presence => true
	accepts_nested_attributes_for :primary_member
	accepts_nested_attributes_for :secondary_members, :reject_if => :all_blank
	accepts_nested_attributes_for :boats, :reject_if => :all_blank

	accepts_nested_attributes_for :duties, :reject_if => :duty_not_populated


	scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
	scope :ordered_by_year, Proc.new{ order("DATE_PART('year', created_at) DESC") }

	def spreadsheet_columns
		[
			['Renewal ID', id],
			['Payment Reference', reference],
			['Total Cost', total_cost],
			['Membership Class', membership_class],
			['Membership Cost', membership_cost],
			['Berthing Costs', berthing_cost],
			['Address', [address_1, address_2, postcode].compact.join(", ")],
			['Primary Member', primary_member&.described],
			['Secondary Members', secondary_members&.described],
			['Boats', boats.described],
			# ['Duties', duties.described],
			['Comment', comment]
		]
	end

	def duty_invite_columns
		[
			['Email', primary_member&.email],
			['Names', secondary_members&.map{|m| m.full_name}&.join(';')]
		]
	end

	def all_members
		secondary_members
	end

	def all_display_name_emails
		(all_members).map do |member|
			"#{member.full_name} <#{member.email}>"
		end

	end
	
	def duty_not_populated(duty)
		duty["exclude"].blank? and duty["request"].blank?
	end

	after_create :generate_reference

	def excluded_dates=(val)
		excluded = val.split(',')
		excluded.each_slice(3) do |dates|
			new_duty(dates, 'exclude')
		end
	end

	def preferred_dates=(val)
		preferred = val.split(',')
		preferred.each_slice(3) do |dates|
			new_duty(dates, 'request')
		end
	end

	def new_duty(dates, preference)
		duties.build(
			preference: preference,
			thursday: Date.parse(dates[0]),
			saturday: Date.parse(dates[1]),
			sunday: Date.parse(dates[2])
		)
	end

	def mark_as_paid!
		write_attribute(:payment_confirmed_at, Time.now.localtime)
		save
	end

	def generate_reference
		if self.primary_member
			write_attribute(:reference, "#{self.primary_member.email[0..8]}-#{self.id}".gsub(/[@\.-]/, ''))
			save
		end
	end

	def to_param
		self.reference
	end

	def self.membership_classes
		{
			'Full' => {
				title: 'Full/Family',
				description: 'Includes partner and children under 18',
				feature_1: 'Full use of facilities and club boats',
				feature_2: 'Free safety boat training',
				ui_class: 'family',
				ui_id: 'family-membership',
				name: 'Full',
				cost: 185
			},
			'Cadet' => {
				title: 'Cadet',
				description: '18 years and above in full-time education',
				feature_1: 'Full use of facilities and club boats',
				feature_2: 'Free safety boat training',
				ui_class: '',
				ui_id: 'cadet-membership',
				name: 'Cadet',
				cost: 58
			},
			'Retained' => {
				title: 'Retained',
				description: 'Includes partner and children under 18',
				feature_1: 'Retain link with the club while away or unable to sail',
				feature_2: '&nbsp;',
				ui_class: '',
				ui_id: 'retained-membership',
				name: 'Retained',
				cost: 26
			},
			'Honorary' => {
				title: 'Honourary',
				description: 'Invitation only!<br/>&nbsp;',
				feature_1: 'Full use of facilities and club boats',
				feature_2: 'Free safety boat training',
				ui_class: '',
				ui_id: 'honorary-membership',
				name: 'Honorary',
				cost: 0
			}
		}


			# 'Full or Familiy Membership (includes partner and children under 18)', 'Full'],
			# ['Cadet Membership (18 years and above in full-time education)', 'Cadet'],
			# ['Retained Member (non-active sailor)', 'Retained'],
			# ['Honorary Member', 'Honorary']
	end

	def self.membership_costs(membership_class)
		membership_classes[membership_class].try(:[], :cost)
	end

	def self.berthing_costs
		{boat: 50, sailboard: 20}
	end

	def membership_cost
		Renewal::membership_costs(self.membership_class) || 0
	end

	def berthing_cost
		boat_total = boats.is_dinghy.where(:berthing => true).count * Renewal::berthing_costs[:boat]
		sailboardboard_total = boats.is_sailboard.where(:berthing => true).count * Renewal::berthing_costs[:sailboard]
		boat_total + sailboardboard_total
	end

	def total_cost
		membership_cost + berthing_cost
	end

	def self.recent
		where(:created_at => 1.week.ago..Time.now)
	end

	def to_s
		"#{self.primary_member.try :full_name} (#{membership_class} #{created_at.year})"
	end

	def secondary_member_count
		self.secondary_members.count
	end

	def boat_count
		self.boats.count
	end

	def year
		self.created_at.year
	end



end
