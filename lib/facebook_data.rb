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
    runner
  end

  def runner
    get_personal_info
    get_friend_count
    get_photos
    get_age
    get_pronouns
    clean_data
    add_missing_data
  end

  def suppliment_data(key)
    if data[key] == nil
      data[key] = "unknown #{key.to_s}"
    end
  end

  def suppliment_college_data
    if @data[:college] == nil
      data[:college] = {:name => "unknown college", :year =>"unknown year"}
    end
  end

  def add_missing_data
    keys = [ :name, :hometown, :high_school, :age, :first_name, :location, :work, :total_friends, :email, :website]
    keys.each do |key|
      suppliment_data(key)
    end
    suppliment_college_data
  end

  def get_pronouns
    if data[:gender]
      if data[:gender] == "female"
        data[:pronoun] = "she"
        data[:possesive_pronoun] = "her"
      elsif data[:gender] == "male" 
        data[:pronoun] = "he"
        data[:possesive_pronoun] = "his"
      else
        data[:pronoun] = "he/she"
        data[:possesive_pronoun] = "his/her"
      end
    end
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
    if data[:work]
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
  end

  def get_age
    if data[:birthday]
      bd = data[:birthday].split("/").collect {|s| s.to_i }
      birthday = DateTime.new(bd[2], bd[0], bd[1])
      now = Time.now.utc.to_date
      age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
      data[:age] = age
    end
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
    total = friend_data["friends"]["summary"]["total_count"]
    formatted_total = total.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    data[:total_friends] = formatted_total
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