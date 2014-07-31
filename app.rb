require 'bundler'
Bundler.require
require './lib/facebook_data.rb'
require "pry"

class App < Sinatra::Application

  get "/" do
    @root = ENV["ROOT_URL"]
    binding.pry
    erb :index
  end

  get '/callback' do
    redirect_uri = "#{ENV["ROOT_URL"]}/user"
    code = params["code"]
    binding.pry
    redirect "https://graph.facebook.com/oauth/access_token?client_id=#{ENV["APP_ID"]}&redirect_uri=#{redirect_uri}&client_secret=#{ENV["APP_SECRET"]}&code=#{code}"
  end

  get '/user' do
    binding.pry
    token = params["access_token"]
    @data = FacebookData.new(token).main
    erb :result
  end

end