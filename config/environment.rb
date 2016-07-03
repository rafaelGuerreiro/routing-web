# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: '587',
  authentication: :plain,
  user_name: Figaro.env.sendgrid_username,
  password: Figaro.env.sendgrid_password,
  domain: 'heroku.com',
  enable_starttls_auto: true
}