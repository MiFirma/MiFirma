# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MiFirma2::Application.initialize!

# Tractis Configuration
TRACTIS_USER = 'tractis'
TRACTIS_DOMAIN = 'mifirma.com'
TRACTIS_PASS = ENV['MIFIRMA_PASS']

