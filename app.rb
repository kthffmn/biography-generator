require 'bundler'
Bundler.require
require './lib/facebook_data.rb'

class App < Sinatra::Application

  get "/" do
    
    erb :index
  end

	get '/callback' do
    
    redirect "/"
	end

end