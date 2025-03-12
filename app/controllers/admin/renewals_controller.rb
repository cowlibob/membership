module Admin
  class RenewalsController < Admin::ApplicationController
    def index
      @renewals = Renewal.paginate(page: params[:page], per_page: 10).order('created_at DESC')
    end

    def show
      @renewal = Renewal.find(params[:id])
    end
  end
end
