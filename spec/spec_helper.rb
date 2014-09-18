# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'omniauth'
require 'webmock/rspec'
require 'sidekiq/testing'
require 'rspec_hue'

Sidekiq::Testing.inline!
WebMock.disable_net_connect!(:allow_localhost => true, :allow => '10.0.1.21')
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
  config.rspec_hue_light_id = 7
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
    stub_request(:get, "https://api.github.com/orgs/eightshapes/issues?access_token=fake-token-here&per_page=100&sort=updated").to_return(:status => 200, :body => eightshapes_issues)
    stub_request(:get, "https://api.github.com/orgs/marriottdigital/issues?access_token=fake-token-here&per_page=100&sort=updated").to_return(:status => 200, :body => marriottdigital_issues)
    stub_request(:get, "https://api.github.com/repos/marriottdigital/Foundations/issues/1347?access_token=fake-token-here").to_return(:status => 200, :body => marriottdigital_single_issue)
    stub_request(:get, "https://api.github.com/repos/marriottdigital/Foundations/issues/13478?access_token=fake-token-here").to_return(:status => 200, :body => marriottdigital_single_issue_closed)
    stub_request(:get, "https://api.github.com/repos/archived/project/issues/1234?access_token=fake-token-here").to_return(:status => 200, :body => open_issue)
    stub_request(:any, /.*api.pusherapp.com*/)
    stub_request(:post, /.*api.pusherapp.com*/).to_return(:status => 200, :body => "{}")
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

def eightshapes_issues
  <<-EOT
  [
    {
      "url": "https://api.github.com/repos/eightshapes/yahoo-backyard-uitech/issues/1347",
      "html_url": "https://github.com/eightshapes/yahoo-backyard-uitech/issues/1347",
      "number": 1347,
      "state": "open",
      "title": "Found a bug",
      "body": "I'm having a problem with this.",
      "user": {
        "login": "detzi",
        "id": 1,
        "avatar_url": "https://github.com/images/error/eightshapes_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/eightshapes",
        "html_url": "https://github.com/eightshapes",
        "followers_url": "https://api.github.com/users/eightshapes/followers",
        "following_url": "https://api.github.com/users/eightshapes/following{/other_user}",
        "gists_url": "https://api.github.com/users/eightshapes/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/eightshapes/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/eightshapes/subscriptions",
        "organizations_url": "https://api.github.com/users/eightshapes/orgs",
        "repos_url": "https://api.github.com/users/eightshapes/repos",
        "events_url": "https://api.github.com/users/eightshapes/events{/privacy}",
        "received_events_url": "https://api.github.com/users/eightshapes/received_events",
        "type": "User",
        "site_admin": false
      },
      "labels": [
        {
          "url": "https://api.github.com/repos/eightshapes/yahoo-backyard-uitech/labels/bug",
          "name": "bug",
          "color": "f29513"
        }
      ],
      "assignee": {
        "login": "jonqdoe",
        "id": 1,
        "avatar_url": "https://github.com/images/error/jonqdoe_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/jonqdoe",
        "html_url": "https://github.com/jonqdoe",
        "followers_url": "https://api.github.com/users/jonqdoe/followers",
        "following_url": "https://api.github.com/users/jonqdoe/following{/other_user}",
        "gists_url": "https://api.github.com/users/jonqdoe/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/jonqdoe/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/jonqdoe/subscriptions",
        "organizations_url": "https://api.github.com/users/jonqdoe/orgs",
        "repos_url": "https://api.github.com/users/jonqdoe/repos",
        "events_url": "https://api.github.com/users/jonqdoe/events{/privacy}",
        "received_events_url": "https://api.github.com/users/jonqdoe/received_events",
        "type": "User",
        "site_admin": false
      },
      "milestone": {
        "url": "https://api.github.com/repos/eightshapes/yahoo-backyard-uitech/milestones/1",
        "number": 1,
        "state": "open",
        "title": "Package 17",
        "description": "",
        "creator": {
          "login": "eightshapes",
          "id": 1,
          "avatar_url": "https://github.com/images/error/eightshapes_happy.gif",
          "gravatar_id": "somehexcode",
          "url": "https://api.github.com/users/eightshapes",
          "html_url": "https://github.com/eightshapes",
          "followers_url": "https://api.github.com/users/eightshapes/followers",
          "following_url": "https://api.github.com/users/eightshapes/following{/other_user}",
          "gists_url": "https://api.github.com/users/eightshapes/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/eightshapes/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/eightshapes/subscriptions",
          "organizations_url": "https://api.github.com/users/eightshapes/orgs",
          "repos_url": "https://api.github.com/users/eightshapes/repos",
          "events_url": "https://api.github.com/users/eightshapes/events{/privacy}",
          "received_events_url": "https://api.github.com/users/eightshapes/received_events",
          "type": "User",
          "site_admin": false
        },
        "open_issues": 4,
        "closed_issues": 8,
        "created_at": "2011-04-10T20:09:31Z",
        "updated_at": "2014-03-03T18:58:10Z",
        "due_on": null
      },
      "comments": 0,
      "pull_request": {
        "url": "https://api.github.com/repos/eightshapes/yahoo-backyard-uitech/pulls/1347",
        "html_url": "https://github.com/eightshapes/yahoo-backyard-uitech/pull/1347",
        "diff_url": "https://github.com/eightshapes/yahoo-backyard-uitech/pull/1347.diff",
        "patch_url": "https://github.com/eightshapes/yahoo-backyard-uitech/pull/1347.patch"
      },
      "closed_at": null,
      "created_at": "2011-04-22T13:33:48Z",
      "updated_at": "2011-04-22T13:33:48Z"
    }
  ]
  EOT
end

def marriottdigital_issues
  <<-EOT
  [
    {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/issues/1347",
      "html_url": "https://github.com/marriottdigital/Foundations/issues/1347",
      "number": 1347,
      "state": "open",
      "title": "Found a bug",
      "body": "I'm having a problem with this.",
      "user": {
        "login": "jamesmelzer",
        "id": 1,
        "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/marriottdigital",
        "html_url": "https://github.com/marriottdigital",
        "followers_url": "https://api.github.com/users/marriottdigital/followers",
        "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
        "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
        "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
        "repos_url": "https://api.github.com/users/marriottdigital/repos",
        "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
        "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
        "type": "User",
        "site_admin": false
      },
      "labels": [
        {
          "url": "https://api.github.com/repos/marriottdigital/Foundations/labels/bug",
          "name": "bug",
          "color": "f29513"
        }
      ],
      "assignee": {
        "login": "jonqdoe",
        "id": 1,
        "avatar_url": "https://github.com/images/error/jonqdoe_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/jonqdoe",
        "html_url": "https://github.com/jonqdoe",
        "followers_url": "https://api.github.com/users/jonqdoe/followers",
        "following_url": "https://api.github.com/users/jonqdoe/following{/other_user}",
        "gists_url": "https://api.github.com/users/jonqdoe/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/jonqdoe/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/jonqdoe/subscriptions",
        "organizations_url": "https://api.github.com/users/jonqdoe/orgs",
        "repos_url": "https://api.github.com/users/jonqdoe/repos",
        "events_url": "https://api.github.com/users/jonqdoe/events{/privacy}",
        "received_events_url": "https://api.github.com/users/jonqdoe/received_events",
        "type": "User",
        "site_admin": false
      },
      "milestone": {
        "url": "https://api.github.com/repos/marriottdigital/Foundations/milestones/1",
        "number": 1,
        "state": "open",
        "title": "August Batch",
        "description": "",
        "creator": {
          "login": "marriottdigital",
          "id": 1,
          "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
          "gravatar_id": "somehexcode",
          "url": "https://api.github.com/users/marriottdigital",
          "html_url": "https://github.com/marriottdigital",
          "followers_url": "https://api.github.com/users/marriottdigital/followers",
          "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
          "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
          "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
          "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
          "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
          "repos_url": "https://api.github.com/users/marriottdigital/repos",
          "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
          "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
          "type": "User",
          "site_admin": false
        },
        "open_issues": 4,
        "closed_issues": 8,
        "created_at": "2011-04-10T20:09:31Z",
        "updated_at": "2014-03-03T18:58:10Z",
        "due_on": null
      },
      "comments": 0,
      "pull_request": {
        "url": "https://api.github.com/repos/marriottdigital/Foundations/pulls/1347",
        "html_url": "https://github.com/marriottdigital/Foundations/pull/1347",
        "diff_url": "https://github.com/marriottdigital/Foundations/pull/1347.diff",
        "patch_url": "https://github.com/marriottdigital/Foundations/pull/1347.patch"
      },
      "closed_at": null,
      "created_at": "2011-04-22T13:33:48Z",
      "updated_at": "2011-04-22T13:33:48Z"
    }
  ]
  EOT
end

def marriottdigital_single_issue
  <<-EOT
  {
    "url": "https://api.github.com/repos/marriottdigital/Foundations/issues/1347",
    "html_url": "https://github.com/marriottdigital/Foundations/issues/1347",
    "number": 1347,
    "state": "open",
    "title": "Found a bug",
    "body": "I'm having a problem with this.",
    "user": {
      "login": "jamesmelzer",
      "id": 1,
      "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/marriottdigital",
      "html_url": "https://github.com/marriottdigital",
      "followers_url": "https://api.github.com/users/marriottdigital/followers",
      "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
      "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
      "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
      "repos_url": "https://api.github.com/users/marriottdigital/repos",
      "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
      "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
      "type": "User",
      "site_admin": false
    },
    "labels": [
      {
        "url": "https://api.github.com/repos/marriottdigital/Foundations/labels/bug",
        "name": "bug",
        "color": "f29513"
      }
    ],
    "assignee": {
      "login": "jonqdoe",
      "id": 1,
      "avatar_url": "https://github.com/images/error/jonqdoe_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/jonqdoe",
      "html_url": "https://github.com/jonqdoe",
      "followers_url": "https://api.github.com/users/jonqdoe/followers",
      "following_url": "https://api.github.com/users/jonqdoe/following{/other_user}",
      "gists_url": "https://api.github.com/users/jonqdoe/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/jonqdoe/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/jonqdoe/subscriptions",
      "organizations_url": "https://api.github.com/users/jonqdoe/orgs",
      "repos_url": "https://api.github.com/users/jonqdoe/repos",
      "events_url": "https://api.github.com/users/jonqdoe/events{/privacy}",
      "received_events_url": "https://api.github.com/users/jonqdoe/received_events",
      "type": "User",
      "site_admin": false
    },
    "milestone": {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/milestones/1",
      "number": 1,
      "state": "open",
      "title": "August Batch",
      "description": "",
      "creator": {
        "login": "marriottdigital",
        "id": 1,
        "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/marriottdigital",
        "html_url": "https://github.com/marriottdigital",
        "followers_url": "https://api.github.com/users/marriottdigital/followers",
        "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
        "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
        "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
        "repos_url": "https://api.github.com/users/marriottdigital/repos",
        "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
        "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
        "type": "User",
        "site_admin": false
      },
      "open_issues": 4,
      "closed_issues": 8,
      "created_at": "2011-04-10T20:09:31Z",
      "updated_at": "2014-03-03T18:58:10Z",
      "due_on": null
    },
    "comments": 0,
    "pull_request": {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/pulls/1347",
      "html_url": "https://github.com/marriottdigital/Foundations/pull/1347",
      "diff_url": "https://github.com/marriottdigital/Foundations/pull/1347.diff",
      "patch_url": "https://github.com/marriottdigital/Foundations/pull/1347.patch"
    },
    "closed_at": null,
    "created_at": "2011-04-22T13:33:48Z",
    "updated_at": "2011-04-22T13:33:48Z"
  }
  EOT
end
def marriottdigital_single_issue_closed
  <<-EOT
  {
    "url": "https://api.github.com/repos/marriottdigital/Foundations/issues/13478",
    "html_url": "https://github.com/marriottdigital/Foundations/issues/13478",
    "number": 13478,
    "state": "closed",
    "title": "Found a bug",
    "body": "I'm having a problem with this.",
    "user": {
      "login": "jamesmelzer",
      "id": 1,
      "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/marriottdigital",
      "html_url": "https://github.com/marriottdigital",
      "followers_url": "https://api.github.com/users/marriottdigital/followers",
      "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
      "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
      "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
      "repos_url": "https://api.github.com/users/marriottdigital/repos",
      "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
      "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
      "type": "User",
      "site_admin": false
    },
    "labels": [
      {
        "url": "https://api.github.com/repos/marriottdigital/Foundations/labels/bug",
        "name": "bug",
        "color": "f29513"
      }
    ],
    "assignee": {
      "login": "jonqdoe",
      "id": 1,
      "avatar_url": "https://github.com/images/error/jonqdoe_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/jonqdoe",
      "html_url": "https://github.com/jonqdoe",
      "followers_url": "https://api.github.com/users/jonqdoe/followers",
      "following_url": "https://api.github.com/users/jonqdoe/following{/other_user}",
      "gists_url": "https://api.github.com/users/jonqdoe/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/jonqdoe/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/jonqdoe/subscriptions",
      "organizations_url": "https://api.github.com/users/jonqdoe/orgs",
      "repos_url": "https://api.github.com/users/jonqdoe/repos",
      "events_url": "https://api.github.com/users/jonqdoe/events{/privacy}",
      "received_events_url": "https://api.github.com/users/jonqdoe/received_events",
      "type": "User",
      "site_admin": false
    },
    "milestone": {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/milestones/1",
      "number": 1,
      "state": "open",
      "title": "August Batch",
      "description": "",
      "creator": {
        "login": "marriottdigital",
        "id": 1,
        "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/marriottdigital",
        "html_url": "https://github.com/marriottdigital",
        "followers_url": "https://api.github.com/users/marriottdigital/followers",
        "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
        "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
        "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
        "repos_url": "https://api.github.com/users/marriottdigital/repos",
        "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
        "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
        "type": "User",
        "site_admin": false
      },
      "open_issues": 4,
      "closed_issues": 8,
      "created_at": "2011-04-10T20:09:31Z",
      "updated_at": "2014-03-03T18:58:10Z",
      "due_on": null
    },
    "comments": 10,
    "pull_request": {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/pulls/1347",
      "html_url": "https://github.com/marriottdigital/Foundations/pull/1347",
      "diff_url": "https://github.com/marriottdigital/Foundations/pull/1347.diff",
      "patch_url": "https://github.com/marriottdigital/Foundations/pull/1347.patch"
    },
    "closed_at": "2011-04-23T13:33:48Z",
    "created_at": "2011-04-22T13:33:48Z",
    "updated_at": "2011-04-22T13:33:48Z"
  }
  EOT
end
def open_issue
  <<-EOT
  {
    "url": "https://api.github.com/repos/archived/project/issues/1234?access_token=fake-token-here",
    "html_url": "https://github.com/repos/archived/project/issues/1234?access_token=fake-token-here",
    "number": 1234,
    "state": "open",
    "title": "Found a bug",
    "body": "I'm having a problem with this.",
    "user": {
      "login": "jamesmelzer",
      "id": 1,
      "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/marriottdigital",
      "html_url": "https://github.com/marriottdigital",
      "followers_url": "https://api.github.com/users/marriottdigital/followers",
      "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
      "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
      "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
      "repos_url": "https://api.github.com/users/marriottdigital/repos",
      "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
      "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
      "type": "User",
      "site_admin": false
    },
    "labels": [
      {
        "url": "https://api.github.com/repos/marriottdigital/Foundations/labels/bug",
        "name": "bug",
        "color": "f29513"
      }
    ],
    "assignee": {
      "login": "jonqdoe",
      "id": 1,
      "avatar_url": "https://github.com/images/error/jonqdoe_happy.gif",
      "gravatar_id": "somehexcode",
      "url": "https://api.github.com/users/jonqdoe",
      "html_url": "https://github.com/jonqdoe",
      "followers_url": "https://api.github.com/users/jonqdoe/followers",
      "following_url": "https://api.github.com/users/jonqdoe/following{/other_user}",
      "gists_url": "https://api.github.com/users/jonqdoe/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/jonqdoe/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/jonqdoe/subscriptions",
      "organizations_url": "https://api.github.com/users/jonqdoe/orgs",
      "repos_url": "https://api.github.com/users/jonqdoe/repos",
      "events_url": "https://api.github.com/users/jonqdoe/events{/privacy}",
      "received_events_url": "https://api.github.com/users/jonqdoe/received_events",
      "type": "User",
      "site_admin": false
    },
    "milestone": {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/milestones/1",
      "number": 1,
      "state": "open",
      "title": "August Batch",
      "description": "",
      "creator": {
        "login": "marriottdigital",
        "id": 1,
        "avatar_url": "https://github.com/images/error/marriottdigital_happy.gif",
        "gravatar_id": "somehexcode",
        "url": "https://api.github.com/users/marriottdigital",
        "html_url": "https://github.com/marriottdigital",
        "followers_url": "https://api.github.com/users/marriottdigital/followers",
        "following_url": "https://api.github.com/users/marriottdigital/following{/other_user}",
        "gists_url": "https://api.github.com/users/marriottdigital/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/marriottdigital/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/marriottdigital/subscriptions",
        "organizations_url": "https://api.github.com/users/marriottdigital/orgs",
        "repos_url": "https://api.github.com/users/marriottdigital/repos",
        "events_url": "https://api.github.com/users/marriottdigital/events{/privacy}",
        "received_events_url": "https://api.github.com/users/marriottdigital/received_events",
        "type": "User",
        "site_admin": false
      },
      "open_issues": 4,
      "closed_issues": 8,
      "created_at": "2011-04-10T20:09:31Z",
      "updated_at": "2014-03-03T18:58:10Z",
      "due_on": null
    },
    "comments": 10,
    "pull_request": {
      "url": "https://api.github.com/repos/marriottdigital/Foundations/pulls/1347",
      "html_url": "https://github.com/marriottdigital/Foundations/pull/1347",
      "diff_url": "https://github.com/marriottdigital/Foundations/pull/1347.diff",
      "patch_url": "https://github.com/marriottdigital/Foundations/pull/1347.patch"
    },
    "closed_at": "",
    "created_at": "2011-04-22T13:33:48Z",
    "updated_at": "2011-04-22T13:33:48Z"
  }
  EOT
end