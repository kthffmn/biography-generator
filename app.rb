require 'bundler'
require 'open-uri'
require 'json'
Bundler.require
require "dotenv"
Dotenv.load
require './lib/facebook_data.rb'

require "pry"

class App < Sinatra::Application

  get "/" do
    @root = ENV["ROOT_URL"]
    erb :index
  end

  get '/callback' do
    redirect_uri = "#{ENV["ROOT_URL"]}/callback"
    code = params["code"]
    user_json = JSON.load(open("https://graph.facebook.com/oauth/access_token?client_id=#{ENV["APP_ID"]}&redirect_uri=#{redirect_uri}&client_secret=#{ENV["APP_SECRET"]}&code=#{code}"))
    token = user_json["access_token"]
    @data = FacebookData.new(token).main
    erb :result
  end

end