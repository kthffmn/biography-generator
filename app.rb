require_relative './config/environment'

class FacebookApp < Sinatra::Application
  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'
  enable :sessions

  get "/" do
    @facebook_url = "https://www.facebook.com/dialog/oauth?client_id=#{ENV["APP_ID"]}&redirect_uri=#{ENV["REDIRECT_URI"]}&scope=email,user_birthday,user_friends,user_photos,user_education_history,user_hometown,user_location,user_website,user_work_history"
    erb :index
  end

  get '/callback' do
    connection = FacebookConnection.new(params["code"])
    session[:access_token] = connection.set_token
    redirect "/result"
  end

  get "/result" do
    @data = FacebookData.new(session[:access_token])
    begin
      @data.run
    rescue
    end
    erb :result
  end

end