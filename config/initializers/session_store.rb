# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_timelogger_session',
  :secret      => 'f99fd3ac985edebb240887ac5fbfe683cb9b476865c6ad49d9f6b1a3005babee71dd255fdf2b2352060a806b83f2d18f972c9eb9f0bc6f1e3694db6d605415d4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
