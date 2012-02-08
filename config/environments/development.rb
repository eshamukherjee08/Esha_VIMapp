EshaVIMapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  
  config.action_mailer.delivery_method = :smtp
 
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => 25,
    :domain => "vinsol.com",
    :authentication => :plain,
    :user_name => "esha.mukherjee@vinsol.com",
    :password => "poohandpiglet"
  }
  SITENAME = 'localhost:3000'
  
  config.action_mailer.default_url_options = { :host => SITENAME}
  config.action_mailer.asset_host = "http://#{SITENAME}"
  
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  
  #set up for default url options

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  
  
  Paperclip.options[:command_path] = "/opt/local/bin"
  
end

