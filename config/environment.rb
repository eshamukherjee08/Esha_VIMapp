if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
end

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EshaVIMapp::Application.initialize!
#config.action_mailer.delivery_method = :test 

