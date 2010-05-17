# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mifirma_session',
  :secret      => '8a3ebc29c22f58bf654c71abb5cb1728594fdebc6393d5d4fbb329b20ca957f5e399b1bb9c78346eff5acbedfbae1a30c49c8edb5739afeb6a0a5756b788de17'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
