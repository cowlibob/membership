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
  	@renewal = Renewal.new(renewal_params)
    @renewal.generate_token!
    if @renewal.save
      begin
        RenewalNotificationMailer.new_renewal_member(@renewal).deliver
        RenewalNotificationMailer.new_renewal_admin(@renewal).deliver
      rescue => e
        Rails.logger.error e.message
        Rails.logger.error e.class
        Rails.logger.error e.backtrace
      end
      redirect_to renewal_path(id: @renewal.reference)
    else
      Rails.logger.error("Failed to save renewal: #{@renewal.errors.full_messages}")
      render :new
    end
  end

  def show
    @renewal = Renewal.where(:reference => [params[:id], params[:id].gsub('-', '')]).first
    @show_payment_link = false # @renewal.payment_id.nil?
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

end
