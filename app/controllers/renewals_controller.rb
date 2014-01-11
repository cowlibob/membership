class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new
    @renewal.build_primary_member
    @renewal.secondary_members.build
    @renewal.boats.build
    @renewal.duties.build
  end

  def create
  	@renewal = Renewal.new(renewal_params)

    return render :new unless @renewal.save

    redirect_to @renewal
  end

  def show
    @renewal = Renewal.where(:reference => params[:id]).first
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

end
