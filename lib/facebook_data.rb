require 'koala'
require 'json'
require 'open-uri'
require 'pry'
require 'date'
require 'time'

class FacebookData
  attr_accessor :data
  attr_reader :token, :graph, :base_url

  def initialize(token)
    @base_url = "https://graph.facebook.com/v2.0/"
    @token = token
    @graph = Koala::Facebook::API.new(token)
    @data = {}
    get_personal_info
    get_friend_count
    get_photos
    get_age
    clean_data
  end

  def clean_data
    clean_locations
    clean_education
    clean_work
  end

  def clean_locations
    location = data[:location]["name"]
    data[:location] = location
    hometown = data[:hometown]["name"]
    data[:hometown] = hometown
  end

  def clean_education
    edu = data[:education]
    data.delete(:education)
    edu.each do |edu|
      if edu["type"] == "High School"
        data[:high_school] = edu["school"]["name"] if edu["school"]["name"]
      elsif edu["type"] == "College"
        data[:college] = {}
        data[:college][:name] = edu["school"]["name"] if edu["school"]["name"]
        data[:college][:year] = edu["year"]["name"] if edu["year"]
      end
    end
  end

  def clean_work   
    work = data[:work]
    data[:work] = []
    work.each do |edu|
      data[:work] << edu["employer"]["name"]
    end
    employers = data[:work]
    if employers.length > 2
      employers[-1].insert(0, "and ")
    end
    temp_string = employers.join(", ")
    data[:work] = temp_string
  end

  def get_age
    bd = data[:birthday].split("/").collect {|s| s.to_i }
    birthday = DateTime.new(bd[2], bd[0], bd[1])
    now = Time.now.utc.to_date
    age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    data[:age] = age
  end

  def get_fb_data(url)
    final_url = base_url + url + "access_token=#{token}"
    temp_data = []
    open(final_url) do |f| 
      f.each_line do |line| 
        temp_data << JSON.parse(line)
      end
    end
    return temp_data[0]
  end

  def get_friend_count
    friend_data = get_fb_data("me?fields=friends&")
    data[:total_friends] = friend_data["friends"]["summary"]["total_count"]
  end

  def get_personal_info
    personal_info = get_fb_data("me?")
    personal_info.each do |k, v|
      data[k.to_sym] = v
    end
  end

  def get_photos
    photo_data = get_fb_data("me/photos?")
    profile_data = get_fb_data("me/picture?redirect=false&")
    data[:profile_photo] = profile_data["data"]["url"]
  end

end