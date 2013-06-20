# Be sure to restart your server when you modify this file.

WebEPM::Application.config.session_store :cookie_store, {
  key: '_webEPM_session',
  secret: 'webEPMsdfsdfsadfsd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# WebEPM::Application.config.session_store :active_record_store
