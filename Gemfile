source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Background processes
gem 'sidekiq'

# Send emails
gem 'postmark-rails'

# Sidekiq ^ monitor runs as a sinatra app inside of rails
gem 'sinatra', '>= 1.3.0', :require => nil

# Performance Monitoring
gem 'newrelic_rpm'

gem "compass-rails"
gem "font-awesome-rails"
gem 'bootstrap-sass', '~> 3.1.1'
gem 'pusher'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
	gem 'rspec-rails'
	gem 'rspec-hue'
end

group :test do
	gem 'shoulda-matchers'
	gem 'simplecov'
	gem 'capybara'
	gem 'poltergeist'
	gem 'fuubar', '~> 2.0.0.rc1'
	gem "webmock"
	gem 'database_cleaner'
	gem 'huey', git: 'git://github.com/Veraticus/huey.git'
	gem 'rspec-legacy_formatters'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :production, :staging do
	gem 'rails_12factor'
end

gem 'omniauth-github'
gem 'net-ssh'
gem 'unicorn'
gem 'devise'
gem "github_api"
gem 'activerecord-session_store', github: 'rails/activerecord-session_store' #prevent cookie overflow errors
ruby "2.0.0"