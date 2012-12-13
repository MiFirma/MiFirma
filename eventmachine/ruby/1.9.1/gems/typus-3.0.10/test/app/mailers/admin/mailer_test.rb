require "test_helper"

class Admin::MailerTest < ActiveSupport::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @url = "http://test.host/admin/account/#{@typus_user.token}"
    @email = Admin::Mailer.reset_password_link(@typus_user, @url)
  end

  should "verify email from is nil by default" do
    assert_nil Admin::Mailer.default[:from]
  end

  should "verify email to is typus user email" do
    assert @email.to.include?(@typus_user.email)
  end

  should "verify email subject" do
    expected = "[#{Typus.admin_title}] Reset password"
    assert_equal expected, @email.subject
  end

  should "verify default email mime_type" do
    assert_equal "text/plain", @email.mime_type
  end

  should "verify email contains reset password link with token" do
    assert_match @url, @email.body.encoded
  end

end
