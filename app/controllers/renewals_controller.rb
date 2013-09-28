class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new
    @renewal.build_primary_member
    @renewal.secondary_members.build
  end

  def create
  	@renewal = Renewal.new(renewal_params)

    return render :new unless @renewal.save
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

end
