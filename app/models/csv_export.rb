class CsvExport < ApplicationRecord

	belongs_to :user

	def populate
		case self.export_type
		when 'renewal'
			self.content = renewals_content
		when 'duties'
			self.content = duties_content
		end

	end

	def filename
		"svsc_#{export_type}_#{year}.csv"
	end

	def entry_count
		self.content.count("\n") - 1
	end

	def renewals_content
		Renewal.by_year(self.year).to_csv()
	end

	def duties_content
		year = self.year
		duties_by_date = Duty.includes(renewal: [:primary_member]).
			by_year(year).
			order(thursday: :asc, saturday: :asc, sunday: :asc).
			select(:id, :renewal_id, :thursday, :saturday, :sunday, :preference).
			all.group_by{|d| d.start_date}

		out = ""
		duties_by_date.map do |date, duties|
			out << date.strftime("%a #{date.day.ordinalize} %b")
			out << "\n"
			out << duties.map{|duty| %Q[#{duty.preference},#{duty.renewal.all_members.map(&:full_name).uniq.join(' & ')}] }.join("\n")
			out << "\n\n\n"
		end

		out
	end
end
