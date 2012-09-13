# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Timetien::Application.initialize!

config_time_zone = "Central Time (US & Canada)"

Timetien::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
end

ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => "587",
    :user_name => "timetien@gmail.com",
    :password => "TimeTien@123",
    :authentication => :plain
}