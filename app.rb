require "dotenv"
Dotenv.load
require 'bundler'
Bundler.require
require 'open-uri'
require 'json'
require './lib/facebook_data.rb'
require 'pry'
class App < Sinatra::Application
  
  enable :sessions

  get "/" do
    @facebook_url = "https://www.facebook.com/dialog/oauth?client_id=#{ENV["APP_ID"]}&redirect_uri=#{ENV["REDIRECT_URI"]}&scope=user_friends"
    erb :index
  end

  get '/callback' do
    code = params["code"]
    url = "https://graph.facebook.com/oauth/access_token?client_id=#{ENV["APP_ID"]}&redirect_uri=#{ENV["REDIRECT_URI"]}&client_secret=#{ENV["APP_SECRET"]}&code=#{code}"

    params = {}
    open(url).read.split("&").each do |param|
      k,v = param.split("=")
      params[k] = v
    end

    session[:access_token] = params["access_token"]
    redirect "/result"
  end

  get "/result" do
    @data = FacebookData.new(session[:access_token]).data
    erb :result
  end

end