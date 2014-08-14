ENV['SINATRA_ENV'] ||= "development"

require "dotenv"
Dotenv.load
require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'json'
require 'open-uri'
require 'date'
require 'time'
require './lib/facebook_data.rb'
require './app.rb'