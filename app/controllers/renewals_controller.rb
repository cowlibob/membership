class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new
  end

  def create
  	@renewal = Renewal.new(renewal_params)
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

end
