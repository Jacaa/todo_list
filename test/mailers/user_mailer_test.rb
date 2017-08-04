require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "activation" do
    user = users(:jack)
    mail = UserMailer.activation(user)
    assert_equal "Activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

end
