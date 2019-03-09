class DutiesController < ApplicationController
  include Clearance::Controller
  before_action :require_login

	def index
		year = params[:year].to_i || Date.today.year
		@event_sources = [
			{
				events: duties_for(year, :requested),
				color: 'green'
			},
			{
				events: duties_for(year, :excluded),
				color: 'red'
			}
		]
  end

  private

  def duties_for(year, preference)
		duties = Duty.includes(renewal: [:primary_member]).
			where('created_at >= ? AND created_at < ?', Date.new(year, 1, 1), Date.new(year + 1, 1, 1))

		duties = duties.send(preference)
		
		duties.map do |duty|
			{
				title: duty.renewal.all_members.map(&:full_name).uniq.join("\n"),
				start: duty.start_date.strftime("%Y-%m-%d"),
				end: (duty.end_date + 1.day).strftime("%Y-%m-%d"),
			}
		end
	end

end
