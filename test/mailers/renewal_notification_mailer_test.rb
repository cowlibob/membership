require 'test_helper'

class RenewalNotificationMailerTest < ActionMailer::TestCase
  test "renewal_reminder" do
    renewal = renewals(:existing_renewal)
    mail = RenewalNotificationMailer.renewal_reminder(renewal)
    
    assert_equal 'Your SVSC Member Renewal - Continue Where You Left Off', mail.subject
    assert_equal [renewal.primary_member.email], mail.to
    assert_equal ['renewals@email.sheffieldviking.org.uk'], mail.from
    assert_match renewal.primary_member.first_name, mail.body.encoded
    assert_match 'started renewing', mail.body.encoded
    assert_match renewal.reference, mail.body.encoded
  end
end
