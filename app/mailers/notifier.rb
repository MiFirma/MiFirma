class Notifier < ActionMailer::Base
  default :from => "info@mifirma.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.ilp_signed.subject
  #
  def ilp_signed (signature)
		@signature=signature
    mail :to => signature.email, :subject => 'ILP firmada. Bienvenido a mifirma.com'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.endorsment_signed.subject
  #
  def endorsment_signed (signature)
		@signature=signature
    mail :to => signature.email, :subject => 'Aval firmado. Bienvenido a mifirma.com'
  end
end
