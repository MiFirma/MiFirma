require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "ilp_signed" do
    mail = Notifier.ilp_signed (signatures(:one))
    assert_equal "ILP firmado. Bienvenido a mifirma.com", mail.subject
    assert_equal ["javier.pena@mifirma.com"], mail.to
    assert_equal ["noreply@mifirma.com"], mail.from
    assert_match "Bienvenido a MIFIRMA", mail.body.encoded
  end

  test "endorsment_signed" do
    mail = Notifier.endorsment_signed (signatures(:one))
    assert_equal "Aval firmado. Bienvenido a mifirma.com", mail.subject
		assert_equal ["javier.pena@mifirma.com"], mail.to
    assert_equal ["noreply@mifirma.com"], mail.from
    assert_match "Bienvenido a MIFIRMA", mail.body.encoded
  end

end
