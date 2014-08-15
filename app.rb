require_relative './config/environment'

class FacebookApp < Sinatra::Application
  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'
  
  enable :sessions

  get "/" do
    base_url = "https://www.facebook.com/dialog/oauth?client_id=#{ENV["APP_ID"]}"
    redirect = "&redirect_uri=#{ENV["REDIRECT_URI"]}"
    scope    = "&scope="
    scopes   = [
      "email",
      "user_birthday",
      "user_friends",
      "user_photos",
      "user_education_history",
      "user_hometown",
      "user_location",
      "user_website",
      "user_work_history"
    ]
    scope << scopes.join(",")
    @facebook_url = base_url + redirect + scope
    erb :index
  end

  get '/callback' do
    code = params["code"]
    binding.pry
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
    @token = session[:access_token]
    begin
      data = FacebookData.new(@token)
      data.run
      @bio = data.bio
      @pic_url = data.pic_url
    rescue
      @bio ||= "Sorry for the inconvenience, but a generated biography is unavailable."
      @pic_url ||= "http://placekitten.com/g/50/50"
    end
    erb :result
  end

end