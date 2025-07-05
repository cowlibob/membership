require 'test_helper'

class ManagementNotificationMailerTest < ActionMailer::TestCase
  test "member_onboarded" do
    member = members(:primary_member)
    mail = ManagementNotificationMailer.member_onboarded(member)
    
    assert_equal "New Member Onboarded - #{member.full_name}", mail.subject
    assert_equal ['membership@sheffieldviking.org.uk', 'vice-commodore@sheffieldviking.org.uk'], mail.to
    assert_equal ['renewals@email.sheffieldviking.org.uk'], mail.from
    assert_match member.full_name, mail.body.encoded
    assert_match member.email, mail.body.encoded
  end
end