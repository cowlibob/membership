class OnboardingJob
  include SuckerPunch::Job

  def perform(onboarding_id)
    onboarding = Onboarding.find(onboarding_id)
    
    # Process each onboarding step
    onboarding.process_google_group
    onboarding.process_website_access
    onboarding.process_whatsapp_invite
    onboarding.process_management_notification
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "OnboardingJob: Onboarding record not found with id #{onboarding_id}: #{e.message}"
  rescue StandardError => e
    Rails.logger.error "OnboardingJob: Error processing onboarding #{onboarding_id}: #{e.message}"
    raise e
  end
end