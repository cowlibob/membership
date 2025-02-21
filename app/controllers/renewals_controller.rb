class RenewalsController < ApplicationController
  def index
  end

  def new
  	@renewal = Renewal.new(membership_class: params[:membership_class])
    @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
    populate_renewal
  end
  
  def edit
    @renewal = find_renewal

    if @renewal.nil?
      flash[:error] = "Sorry, we couldn't find that renewal"
      redirect_to new_renewal_path
      return
    end
    
    @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
    populate_renewal
  end
  
  def create
  	@renewal = Renewal.new(renewal_params)
    @renewal.generate_token!
    if @renewal.save
      @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
      RenewalNotificationMailer.new_renewal_member(@renewal).deliver
      redirect_to edit_renewal_path(@renewal)
    else
      flash[:error] = "There was an error creating the renewal: #{@renewal.errors.full_messages.to_sentence}"
      render :new
      return
    end
  end
  
  def update
    find_renewal
    if @renewal.nil?
      flash[:error] = "Sorry, we couldn't find that renewal"
      redirect_to new_renewal_path
      return
    end

    if @renewal.is_paid?
      flash[:error] = %q[Sorry, you can't update a paid renewal. Please contact <a href="mailto:membership@sheffieldviking.org.uk">membership@sheffieldviking.org.uk</a> to discuss any changes.]
      redirect_to renewal_path(@renewal)
      return
    end

    @renewal.generate_reference
    @renewal.update(renewal_params)
    @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
    
    if @renewal.valid? && @renewal.complete?
      begin
        # RenewalNotificationMailer.new_renewal_member(@renewal).deliver
        RenewalNotificationMailer.renewal_payment_confirmation(@renewal).deliver if @renewal.charge.present?
        RenewalNotificationMailer.new_renewal_admin(@renewal).deliver
      rescue => e
        Rails.logger.error e.message
        Rails.logger.error e.class
        Rails.logger.error e.backtrace
      end
    end
    redirect_to edit_renewal_path(@renewal)
  end
  
  def show
    find_renewal
    if @renewal.nil?
      flash[:error] = "Sorry, we couldn't find that renewal"
      redirect_to new_renewal_path
      return
      return
    end

    if @charge = @renewal.charges.select{|charge| charge.captured?}.first
      @show_payment_link = false # @renewal.payment_id.nil?
    end
    @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
  end

  private

  def find_renewal
    @renewal = Renewal.find_by(reference: [params[:id], params[:id].gsub('-', '')])
  end

  def renewal_params
  	# params.require(:renewal).permit!
    params.require(:renewal).permit(
      :membership_class, :email, :address_1, :address_2, :postcode,
      primary_member_attributes: [:id, :first_name, :last_name, :email, :phone, :dob, :_destroy],
      secondary_members_attributes: [:id, :first_name, :last_name, :email, :phone, :dob, :_destroy],
      boats_attributes: [:id, :name, :type, :berthing, :_destroy],
      duties_attributes: [:id, :preference, :thursday, :saturday, :sunday, :_destroy]
    )
  end

  def populate_renewal
    @renewal.build_primary_member if @renewal.primary_member.nil?
    4.times { @renewal.secondary_members.build} if @renewal.secondary_members.empty?
    @renewal.boats.build if @renewal.boats.empty?
    @renewal.duties.build if @renewal.duties.empty?
  end

end
