require "dotenv"
Dotenv.load
require 'bundler'
Bundler.require
require 'open-uri'
require 'json'
require './lib/facebook_data.rb'


class App < Sinatra::Application

  get "/" do
    @root = ENV["ROOT_URL"]
    erb :index
  end

  get '/callback' do
    redirect_uri = "#{ENV["ROOT_URL"]}/callback"
    code = params["code"]
    html =  Nokogiri::HTML(open("https://graph.facebook.com/oauth/access_token?client_id=#{ENV["APP_ID"]}&redirect_uri=#{redirect_uri}&client_secret=#{ENV["APP_SECRET"]}&code=#{code}"))
    token = html.search("p").children.text[13..-1].gsub(/&expires.+/, "")
    begin
      @data = FacebookData.new(token).main
    rescue
      @data ||= "Koala::Facebook::ServerError: type: OAuthException, code: 1, message: An unknown error has occurred. [HTTP 500]"
    end
    erb :result
  end

end