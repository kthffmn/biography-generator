require 'bundler'
Bundler.require
require './lib/tic_tac_toe.rb'

class App < Sinatra::Application
  @@game = TicTacToe.new

  get "/" do
    redirect "/reset"
  end

	get '/play' do
    @board = @@game.visual_board
    if params
      @message = params["message"]
    end
    erb :index
	end

	post '/move' do
    message = @@game.main_web(params["move"])
    if message
      redirect "/play?message=#{message}"
    else
      redirect "/play"
    end
	end

  get '/reset' do 
    @@game = TicTacToe.new
    redirect "/play"
  end

end