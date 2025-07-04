class Admin::OnboardingController < Admin::ApplicationController
  before_action :set_onboarding, only: [:show, :edit, :update, :destroy]
  before_action :set_member, only: [:new, :create]

  def index
    @onboardings = Onboarding.includes(:member).order(created_at: :desc)
  end

  def show
  end

  def new
    @onboarding = @member.build_onboarding
  end

  def create
    @onboarding = @member.build_onboarding
    
    if @onboarding.save
      OnboardingJob.perform_async(@onboarding.id)
      redirect_to edit_admin_onboarding_path(@onboarding), notice: 'Onboarding process started and queued for processing.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    current_time = Time.current
    
    # Handle mark attempted actions
    if params[:mark_attempted].present?
      case params[:mark_attempted].keys.first
      when 'google_group'
        @onboarding.update(google_group_attempted_at: current_time)
      when 'website'
        @onboarding.update(website_attempted_at: current_time)
      end
    end
    
    # Handle mark complete actions
    if params[:mark_complete].present?
      case params[:mark_complete].keys.first
      when 'google_group'
        @onboarding.update(google_group_added_at: current_time)
      when 'website'
        @onboarding.update(website_added_at: current_time)
      when 'whatsapp'
        @onboarding.update(whatsapp_invite_email_sent_at: current_time)
      when 'management'
        @onboarding.update(management_email_sent_at: current_time)
      end
    end
    
    # Handle regular form updates
    if params[:onboarding].present? && @onboarding.update(onboarding_params)
      redirect_to edit_admin_onboarding_path(@onboarding), notice: 'Onboarding updated successfully.'
    else
      redirect_to edit_admin_onboarding_path(@onboarding), notice: 'Onboarding step updated.'
    end
  end

  def destroy
    @onboarding.destroy
    redirect_to admin_onboardings_path, notice: 'Onboarding was successfully deleted.'
  end

  private

  def set_onboarding
    @onboarding = Onboarding.find(params[:id])
  end

  def set_member
    @member = Member.find(params[:member_id])
  end

  def onboarding_params
    params.require(:onboarding).permit(
      :google_group_attempted_at,
      :google_group_added_at,
      :website_attempted_at,
      :website_added_at,
      :whatsapp_invite_email_sent_at,
      :management_email_sent_at
    )
  end
end