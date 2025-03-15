module Admin
  class RenewalsController < Admin::ApplicationController
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
          find_renewals
        end
        format.csv do
          find_renewals(paginate: false)
          send_data @renewals.to_csv, filename: "renewals-#{Date.today}.csv"
        end
      end
    end

    def show
      @renewal = Renewal.find(params[:id])
    end

    def soft_delete
      notice = error = nil
      renewal = Renewal.find(params[:id])
      if renewal&.update_attribute(:deleted, true)
        link = undelete_admin_renewal_path(renewal.id, request.query_parameters)
        notice = "Renewal for #{renewal} was successfully deleted. #{button_to('Undo', link, method: :patch,
                                                                                             class: 'text-red-500')}".html_safe
      elsif renewal.present?
        error = "Renewal for #{renewal} could not be deleted: #{renewal.errors.full_messages.to_sentence}"
      else
        error = 'Renewal could not be found.'
      end

      redirect_to admin_renewals_path(request.query_parameters), notice: notice, error: error
    end

    def undelete
      notice = error = nil
      renewal = Renewal.find(params[:id])
      if renewal&.update_attribute(:deleted, false)
        notice = "Renewal for #{renewal} was successfully restored."
      elsif renewal.present?
        error = "Renewal for #{renewal} could not be restored: #{renewal.errors.full_messages.to_sentence}"
      else
        error = 'Renewal could not be found.'
      end

      redirect_to admin_renewals_path(request.query_parameters), notice: notice, error: error
    end

    private

    def find_renewals(paginate: true)
      scope = Renewal.not_deleted
      scope = scope.where("date_part('year', created_at) = ?", @year) if @year.present?
      scope = scope.order('created_at DESC')

      @renewals = if paginate
                    scope.paginate(page: params[:page], per_page: 10)
                  else
                    scope
                  end
    end
  end
end
