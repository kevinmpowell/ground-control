# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'omniauth'
require 'webmock/rspec'
require 'sidekiq/testing'

Sidekiq::Testing.inline!
# WebMock.disable_net_connect!(:allow_localhost => true, :allow => "http://www.meethue.com/api/nupnp/")
WebMock.allow_net_connect!
Capybara.javascript_driver = :poltergeist

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      :provider => 'github',
      :uid => '123456789'
      # etc.
    })

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
    config.mock_with :rspec
   config.infer_base_class_for_anonymous_controllers = false
   config.use_transactional_fixtures = false
   config.include Warden::Test::Helpers
   config.include Devise::TestHelpers, :type => :controller




  class ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil
   
    def self.connection
      @@shared_connection || retrieve_connection
    end
  end
  # Forces all threads to share the same connection. This works on
  # Capybara because it starts the web server in a thread.
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    require "#{Rails.root}/db/seeds.rb"
  end
  
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end


  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    Warden.test_mode!
    @current_user = User.create({email:'john@example.com', password:'blahblah', github_username:'foo', name:'John Doe', auth_token:'fake-token-here', admin: true, uid: '123456789', provider: 'github'})
    login_as(@current_user, :scope => :user)
  end


  config.after(:each) do
    Warden.test_reset!
    DatabaseCleaner.clean
  end
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end