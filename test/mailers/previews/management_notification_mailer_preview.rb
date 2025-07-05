class ManagementNotificationMailerPreview < ActionMailer::Preview
  def member_onboarded
    member = Member.joins(:onboarding).first || Member.first
    ManagementNotificationMailer.member_onboarded(member)
  end
end