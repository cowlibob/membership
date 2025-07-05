require "test_helper"

class WhatsappInviteMailerTest < ActionMailer::TestCase
  test "invite_member" do
    mail = WhatsappInviteMailer.invite_member
    assert_equal "Invite member", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
