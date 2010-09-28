# Load the rails application
require File.expand_path('../application', __FILE__)

# no real mail for now
Depot::Application.configure do
  config.action_mailer.delivery_method = :test  
end

# Initialize the rails application
Depot::Application.initialize!
