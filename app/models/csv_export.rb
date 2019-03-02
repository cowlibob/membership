class CsvExport < ApplicationRecord

	belongs_to :user

	def populate
		self.content = Renewal.by_year(self.year).to_csv()
	end

	def filename
		"membership_#{year}.csv"
	end

	def entry_count
		self.content.count("\n") - 1
	end
end
