class ManagementNotificationMailer < ApplicationMailer
  def member_onboarded(member)
    @member = member
    @onboarding = member.onboarding
    
    mail(
      to: ['membership@sheffieldviking.org.uk', 'vice-commodore@sheffieldviking.org.uk'],
      subject: "New Member Onboarded - #{@member.full_name}"
    )
  end
end