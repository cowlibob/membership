module Admin
  class MembersController < Admin::ApplicationController
    include ActionView::Helpers::UrlHelper
    def index
      params[:year] ||= Time.zone.now.year
      @year = if params[:year] == 'all'
                nil
              else
                params[:year].to_i
              end
      @years_collection = ((Date.today.year - 10..Date.today.year).map do |year|
        [year, year]
      end).reverse.unshift(['All', :all])

      respond_to do |format|
        format.html do
          find_members
        end
        format.csv do
          find_members(paginate: false)
          send_data @members.to_csv, filename: "members-#{Date.today}.csv"
        end
      end
    end

    def show
      @member = Member.find(params[:id])
    end

    private

    def find_members(paginate: true)
      scope = Member
      scope = scope.where("date_part('year', created_at) = ?", @year) if @year.present?
      scope = scope.order('created_at DESC')

      @members = if paginate
                   scope.paginate(page: params[:page], per_page: 10)
                 else
                   scope
                 end
    end
  end
end
