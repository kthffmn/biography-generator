class FacebookConnection
  attr_reader :url
  attr_accessor :token

  def initialize(code)
    @url = "https://graph.facebook.com/oauth/access_token?client_id=#{ENV["APP_ID"]}&redirect_uri=#{ENV["REDIRECT_URI"]}&client_secret=#{ENV["APP_SECRET"]}&code=#{code}"
    @token = "unknown"
  end

  def set_token
    begin
      open(url).read.split("&").each do |param|
        if param =~ /access_token(.*)/ 
          self.token = param.split("=")[1]
        end
      end
    end
    return token
  end

end
