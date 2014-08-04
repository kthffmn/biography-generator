require 'koala'
require 'json'
require 'open-uri'
require 'pry'
require 'date'
require 'time'

class FacebookData
  attr_accessor :user_data
  attr_reader :token, :graph, :base_url

  def initialize(token)
    @base_url = "https://graph.facebook.com/v2.0/"
    @token = token
    @graph = Koala::Facebook::API.new(token)
    @user_data = {}
  end

  def runner
    get_personal_info
    get_friend_count
    get_photos
    get_age
    user_data
  end

  def get_age
    bd = user_data[:birthday].split("/").collect {|s| s.to_i }
    birthday = DateTime.new(bd[2], bd[0], bd[1])
    now = Time.now.utc.to_date
    age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    user_data[:age] = age
  end

  def get_fb_data(url)
    final_url = base_url + url + "access_token=#{token}"
    data = []
    open(final_url) do |f| 
      f.each_line do |line| 
        data << JSON.parse(line)
      end
    end
    return data[0]
  end

  def get_friend_count
    friend_data = get_fb_data("me?fields=friends&")
    user_data[:total_friends] = friend_data["friends"]["summary"]["total_count"]
  end

  def get_personal_info
    personal_info = get_fb_data("me?")
    personal_info.each do |k, v|
      user_data[k.to_sym] = v
    end
  end

  def get_photos
    photo_data = get_fb_data("me/photos?")
    profile_data = get_fb_data("me/picture?redirect=false&")
    user_data[:profile_photo] = profile_data["data"]["url"]
  end

end