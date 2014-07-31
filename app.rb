require "dotenv"
Dotenv.load
require 'bundler'
Bundler.require
require 'open-uri'
require 'json'
require './lib/facebook_data.rb'


class App < Sinatra::Application
  
  enable :sessions

  get "/" do
    if session[:access_token].nil?
      @facebook_url = "https://www.facebook.com/dialog/oauth?client_id=#{ENV["APP_ID"]}&redirect_uri=#{ENV["REDIRECT_URI"]}"
      erb :index
    else
      redirect '/result'
    end
  end

  get '/callback' do
    code = params["code"]
    html =  Nokogiri::HTML(open("https://graph.facebook.com/oauth/access_token?client_id=#{ENV["APP_ID"]}&redirect_uri=#{ENV["REDIRECT_URI"]}&client_secret=#{ENV["APP_SECRET"]}&code=#{code}"))
    token = html.search("p").children.text[13..-1].gsub(/&expires.+/, "")
    session[:access_token] = token
    redirect "/result"
  end

  get "/result" do
    begin
      @data = FacebookData.new(session[:access_token]).main
    rescue
      @data ||= "error has occurred"
    end
    erb :result
  end

end