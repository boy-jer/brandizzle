# Edit at your own peril - it's recommended to regenerate this file
# in the future when you upgrade to a newer version of Cucumber.

# IMPORTANT: Setting config.cache_classes to false is known to
# break Cucumber's use_transactional_fixtures method.
# For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem 'cucumber-rails',   :lib => false,         :version => '>= 0.2.4'
config.gem 'database_cleaner', :lib => false,         :version => '>= 0.4.3'
config.gem 'capybara',         :lib => false,         :version => '>= 0.3.0'
config.gem 'rspec',            :lib => false,         :version => '>= 1.3.0'
config.gem 'rspec-rails',      :lib => false,         :version => '>= 1.3.2'
config.gem 'factory_girl',                            :version => '>= 1.2.3'
config.gem 'pickle',           :lib => false,         :version => '>= 0.2.1'
config.gem 'email_spec',       :lib => 'email_spec',  :version => '>= 0.4.0'