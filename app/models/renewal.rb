class Renewal < ActiveRecord::Base

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

	def membership_classes
		[
			['Full or Familiy Membership (includes partner and children under 18)', 'Full'],
			['Cadet Membership (18 years and above in full-time education)', 'Cadet'],
			['Retained Member (non-active sailor)', 'Retained'],
			['Honorary Member', 'Honorary']
		]
	end

	def membership_cost
		{'Full' => 150, 'Cadet' => 58, 'Retained' => 26, 'Honorary' => 0}[self.membership_class] || 0
	end

	def berthing_cost
		boats.where(:berthing => true).count * 45
	end

	def total_cost
		membership_cost + berthing_cost
	end

	def self.recent
		where(:created_at => 1.week.ago..Time.now)
	end

	def to_s
		"#{self.primary_member.try :full_name} #{membership_class}"
	end

	def secondary_member_count
		self.secondary_members.count
	end

	def boat_count
		self.boats.count
	end



end
