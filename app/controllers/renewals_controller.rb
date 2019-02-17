class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new
    @renewal.build_primary_member
    4.times { @renewal.secondary_members.build}
    @renewal.boats.build
    @renewal.duties.build
  end

  def create
    binding.pry
  	@renewal = Renewal.new(renewal_params)

    return render :new unless @renewal.save

    binding.pry
    redirect_to renewal_path(id: @renewal.reference)
  end

  def show
    @renewal = Renewal.where(:reference => [params[:id], params[:id].gsub('-', '')]).first
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

end
