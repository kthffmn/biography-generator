require 'bundler'
Bundler.require
require './lib/facebook_data.rb'
require "pry"

class App < Sinatra::Application
  APP_SECRET = ""

  APP_ID = "547986201993556"

  get "/" do
    erb :index
  end

	get '/callback' do
    binding.pry
    @user = FacebookData.new(params["code"])
    @user_data = @user.main
    redirect "/"
	end

end

# access token -9n4OOfNziWuHZvWtaAharIL0MtP5Y3OcNCbKriUcbWamEh0YaS8erc6KAxn_6gFYfcLfnyFrUFHfmpacjrfBnzXmzpALmTasORN5vqrkp1f8qPyrQVi8YtR8AUgX-tKePfUmXP1Yn4xg2A0ol5zxlET6L2LNPt_T8IkBA1wy1O-rhXnysoOmH_UaE4nbXls0_CrRZ1cgl7DlSCTpIey5ARZEKO3tvx4_m2Zorqfa2EsllSzjmAdBvWKbZFd1kvz40stB-f3HxTnDZd-Yrugk08yIY2aCV_D7204IrGzSjhGcayMW0mXSxob [HTTP 400]
# from /Users/katie/.rvm/gems/ruby-2.1.0/gems/koala-1.10.0/lib/koala/api/graph_api.rb:503:in `block in graph_call'