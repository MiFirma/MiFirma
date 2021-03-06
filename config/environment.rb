# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MiFirma2::Application.initialize!

# Tractis Configuration
#TRACTIS_USER = 'tractis'
#TRACTIS_DOMAIN = 'mifirma.com'
#TRACTIS_PASS = ENV['MIFIRMA_PASS']


# ActionMailer::Base.smtp_settings = {
#   :address        => 'smtp.acumbamail.com',
#   :port           => '25',
#   :authentication => :plain,
#   :user_name      => ENV['ACUMBAMAIL_USERNAME'],
#   :password       => ENV['ACUMBAMAIL_PASSWORD'],
# }


# Sengrid in heroku
ActionMailer::Base.smtp_settings = {
 :address        => 'smtp.sendgrid.net',
 :port           => '587',
 :domain   		 => 'mifirma.com',
 :authentication => :plain,
 :user_name      => ENV['SENDGRID_USERNAME'],
 :password       => ENV['SENDGRID_PASSWORD'],
 :domain         => 'heroku.com',
 :enable_starttls_auto => true
}
