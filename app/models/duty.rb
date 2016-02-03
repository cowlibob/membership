class Duty < ActiveRecord::Base
	belongs_to :renewal

	scope :by_year, Proc.new{|year| where(["DATE_PART('year', created_at) = ?", year]) }
	
  def request=(value)
    self.preference = 'request' unless value.blank?
  end

  def request
    self.preference == 'request'
  end

  def exclude=(value)
    self.preference = 'exclude' unless value.blank?
  end

  def exclude
    self.preference == 'exclude'
  end

	def week_containing=(date)
		date = Date.strptime(date, '%Y-%m-%d')
		monday = date + (1 - date.cwday).days
		self.thursday = sailing_day(monday + 3.days)
		self.saturday = sailing_day(monday + 5.days)
		self.sunday = sailing_day(monday + 6.days)

		#TODO: is_sailing_day?() not correct

	end

	def week_containing
		[thursday, saturday, sunday].compact.first
	end

	def to_s
		[thursday, saturday, sunday].compact.join(', ')
	end

	private

	def sailing_day(date)
		is_sailing_day?(date) ? date : nil
	end

	APRIL = 4
	MAY = 5
	AUGUST = 8
	OCTOBER = 10

	def is_in_season?(date)
    	date.month >= APRIL && date.month <= OCTOBER;
  	end

	def is_thursday?(date)
    	date.month >= MAY && date.month <= AUGUST && date.thursday?
  	end

	def is_nth_saturday?(date, n)
    	date.saturday? && (date.mday > (7 * (n - 1))) && (date.mday <= (7 * (n)));
  	end

	def is_sailing_day?(date)
    	is_in_season?(date) && (date.sunday? ||	is_nth_saturday?(date, 2) || is_thursday?(date) )
  	end
end
