class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new
    @renewal.build_primary_member
    4.times { @renewal.secondary_members.build}
    @renewal.boats.build
    @renewal.duties.build
    @weeks = duty_weeks
  end

  def create
  	@renewal = Renewal.new(renewal_params)

    return render :new unless @renewal.save

    redirect_to @renewal
  end

  def show
    @renewal = Renewal.where(:reference => [params[:id], params[:id].gsub('-', '')]).first
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

  def duty_weeks
    all = Date.new(2016, 03, 30).step(Date.new(2016, 10, 20)).select{|d| d.monday?}
    all
  end

end
