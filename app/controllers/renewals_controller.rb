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
    # Check for existing renewal with same primary member email in current year
    primary_member_email = renewal_params.dig(:primary_member_attributes, :email)
    
    if primary_member_email.present?
      existing_renewal = find_existing_renewal_by_email(primary_member_email.downcase.strip)
      
      if existing_renewal.present?
        # Send reminder email and show message
        RenewalNotificationMailer.renewal_reminder(existing_renewal).deliver
        
        flash[:notice] = "You already have a renewal in progress for #{Date.current.year}. We've sent you an email with a link to continue updating your renewal."
        redirect_to new_renewal_path
        return
      end
    end
    
    @renewal = Renewal.new(renewal_params)
    @renewal.generate_token!
    if @renewal.save
      @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
      RenewalNotificationMailer.new_renewal_member(@renewal).deliver
      redirect_to edit_renewal_path(@renewal)
    else
      flash[:error] = "There was an error creating the renewal: #{@renewal.errors.full_messages.to_sentence}"
      render :new
      nil
    end
  end

  def update
    find_renewal
    Rails.logger.info "Updating renewal: #{@renewal.email}"
    if @renewal.nil?
      flash[:error] = "Sorry, we couldn't find that renewal"
      redirect_to new_renewal_path
      return
    end

    if @renewal.is_paid?
      flash[:error] =
        %q(Sorry, you can't update a paid renewal. Please contact <a href="mailto:membership@sheffieldviking.org.uk">membership@sheffieldviking.org.uk</a> to discuss any changes.)
      redirect_to renewal_path(@renewal)
      return
    end

    @renewal.generate_reference
    @renewal.update(renewal_params)
    @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step

    send_email_notitifactions
    if @renewal.valid?
      if @renewal.complete?
        begin
          redirect_to renewal_path(@renewal)
          return
        rescue StandardError => e
          Rails.logger.error e.message
          Rails.logger.error e.class
          Rails.logger.error e.backtrace
        end
      end
    else
      flash[:error] = @renewal.errors.full_messages.to_sentence
    end
    populate_renewal
    if @renewal_step_with_override == :payment
      render :show
    else
      render :edit
    end
  end

  def show
    find_renewal
    if @renewal.nil?
      flash[:error] = "Sorry, we couldn't find that renewal"
      redirect_to new_renewal_path
      return
    end

    if @charge = @renewal.charges.select { |charge| charge.captured? }.first
      @show_payment_link = false # @renewal.payment_id.nil?
    end

    @renewal_step_with_override = params[:step]&.to_sym || @renewal.current_step
    populate_renewal
  end

  private

  def find_existing_renewal_by_email(email)
    # Find existing renewal with matching primary member email in current year
    Renewal.joins(:primary_member)
           .where(members: { email: email, primary: true })
           .where("DATE_PART('year', renewals.created_at) = ?", Date.current.year)
           .not_deleted
           .first
  end

  def send_email_notitifactions
    return unless @renewal.present?
    return unless @renewal.persisted?

    return unless @renewal.complete?

    if @renewal.is_paid?
      # RenewalNotificationMailer.renewal_payment_confirmation(@renewal).deliver
    else
      RenewalNotificationMailer.renewal_payment_pending(@renewal).deliver
    end

    # Note to hook up renewal_paid_by_bank_transfer email here if marked as such.

    # begin
    #   # RenewalNotificationMailer.new_renewal_member(@renewal).deliver
    #   debugger
    #   RenewalNotificationMailer.renewal_payment_confirmation(@renewal).deliver if @renewal.is_paid?
    #   RenewalNotificationMailer.new_renewal_admin(@renewal).deliver
    # rescue StandardError => e
    #   Rails.logger.error e.message
    #   Rails.logger.error e.class
    #   Rails.logger.error e.backtrace
    # end
  end

  def find_renewal
    @renewal = Renewal.find_by(reference: [params[:id], params[:id].gsub('-', '')])
  end

  def renewal_params
    # params.require(:renewal).permit!
    res = params.require(:renewal).permit(
      :membership_class, :email, :address_1, :address_2, :postcode, :no_boats,
      :emergency_contact_details, :comment, :share_data_for_commission, :declaration_confirmed,
      :bank_transfer_payment_reported_at,
      primary_member_attributes: %i[id first_name last_name email phone dob _destroy],
      secondary_members_attributes: %i[id first_name last_name email phone dob _destroy],
      boats_attributes: %i[id berthing is_sailboard classname sail_number hull_colour name insured _destroy],
      duties_attributes: %i[id preference thursday saturday sunday _destroy]
    )

    res[:email] = res[:email].downcase.strip if res[:email].present?
    res[:bank_transfer_payment_reported_at] = Time.now if res[:bank_transfer_payment_reported_at] == 'true'
    res.delete(:boats_attributes) if res[:no_boats] == '1'
    res
  end

  def populate_renewal
    @renewal.build_primary_member if @renewal.primary_member.nil?
    # 4.times { @renewal.secondary_members.build } if @renewal.secondary_members.empty?
    @renewal.secondary_members.build if @renewal.secondary_members.empty?
    @renewal.boats.build if @renewal.boats.empty?
    @renewal.duties.build if @renewal.duties.empty?
  end
end
