class Duty < ActiveRecord::Base
	belongs_to :renewal

	def week_containing=(date)
		date = Date.strptime(date, '%d/%m/%Y')
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

	def before_save
		binding.pry
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
