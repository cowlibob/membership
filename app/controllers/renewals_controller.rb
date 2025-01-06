class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new(membership_class: params[:membership_class])
    populate_renewal
  end

  def edit
    @renewal = Renewal.find(params[:id])
    populate_renewal
  end

  def create
  	@renewal = Renewal.new(renewal_params)
    @renewal.generate_token!
    @renewal.save

    redirect_to edit_renewal_path(id: @renewal.id)

  end

  def update
    @renewal = Renewal.find(params[:id])
    @renewal.generate_reference
    @renewal.update(renewal_params)
    if @renewal.complete?
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
      redirect_to edit_renewal_path(id: @renewal.id)
    end
  end

  def show
    @renewal = Renewal.where(:reference => [params[:id], params[:id].gsub('-', '')]).first
    if @charge = @renewal.charges.select{|charge| charge.captured?}.first
      @show_payment_link = false # @renewal.payment_id.nil?
    end
  end

  private

  def renewal_params
  	params.require(:renewal).permit!
  end

  def populate_renewal
    @renewal.build_primary_member if @renewal.primary_member.nil?
    4.times { @renewal.secondary_members.build} if @renewal.secondary_members.empty?
    @renewal.boats.build if @renewal.boats.empty?
    @renewal.duties.build if @renewal.duties.empty?
  end

end
