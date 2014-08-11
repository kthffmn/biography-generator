ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
require 'capybara/rspec'
require 'capybara/dsl'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Capybara::DSL
  config.order = 'default'
end