# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_partidodeinternet_session',
  :secret      => '87dfb1b2ba52e6c5cd598018df59f53c879063947f47f334f0c78cc04e227395ca4ec0c900df7d82d30b6238e442458581512c32263ed5d9373a0d715112a375'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
