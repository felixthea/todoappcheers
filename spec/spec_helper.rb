# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = "random"
end

def sign_up(username)
  visit new_user_url
  fill_in 'Username', :with => username
  fill_in 'Password', :with => "biscuits"
  click_on "Create User"
end

def sign_up_as_hello_world
  sign_up("hello_world")
end

def sign_in_as_hello_world
  sign_up_as_hello_world
  click_on "Sign Out"
  visit new_session_url
  fill_in 'Username', :with => "hello_world"
  fill_in 'Password', :with => "biscuits"
  click_on "Log In"
end

def factory_sign_up
  user = FactoryGirl.create(:complete_user)
  factory_sign_in(user.username, user.password)
  user
end

def factory_sign_in(username,password)
  visit new_session_url
  fill_in 'Username', :with => username
  fill_in 'Password', :with => password
  click_on "Log In"
end


def create_user_with_goals
  user = FactoryGirl.create(:complete_user)
  user.goals.create(personal: false, name: "Public incomplete goal")
  user.goals.create(personal: false, name: "Public completed goal", completed: true)
  user.goals.create(personal: true, name: "Private incomplete goal")
  user.goals.create(personal: true, name: "Private completed goal", completed: true)
  user
end