require 'koala'
require 'json'
require 'open-uri'
require 'pry'
require 'date'
require 'time'

# @data[:name] hails from 
# @data[:hometown], where 
# @data[:pronoun] attended 
# @data[:high_school]. 
# @data[:pronoun].capitalize went on to 
# @data[:college][:name] where 
# @data[:pronoun] graduated in 
# @data[:college][:year]. Now 
# @data[:age], 
# @data[:first_name] lives in 
# @data[:location] and has worked at 
# @data[:work]. 
# @data[:pronoun].capitalize has 
# @data[:total_friends] total Facebook friends and can be reached at 
# @data[:email] 
# @data[:possesive_pronoun].capitalize %> website is 
# @data[:website]</a>.

class FacebookData
  attr_accessor :data, :bio, :pic_url, :name_pronouns
  attr_reader :token, :graph, :base_url

  def initialize(token)
    @base_url = "https://graph.facebook.com/v2.0/"
    @token = token
    @graph = Koala::Facebook::API.new(token)
    @data = {}
    @name_pronouns = {}
    @bio = ""
    @pic_url = ""
  end

  def runner
    get_personal_info
    get_pronouns
    get_names
    add_hometown
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

  def get_personal_info
    personal_info = get_fb_data("me?")
    personal_info.each do |k, v|
      data[k] = v
    end
  end

  def get_pronouns
    if data["gender"]
      if data["gender"] == "female"
        name_pronouns[:pronoun] = "she"
        name_pronouns[:possesive_pronoun] = "her"
      elsif data["gender"] == "male" 
        name_pronouns[:pronoun] = "he"
        name_pronouns[:possesive_pronoun] = "his"
      else
        name_pronouns[:pronoun] = "he/she"
        name_pronouns[:possesive_pronoun] = "his/her"
      end
    end
  end

  def get_names
    ["first_name", "name"].each do |key|
      if data[key]
        name_pronouns[key.to_sym] = data[key]
      else
        name_pronouns[key.to_sym] = name_pronouns[:pronoun]
      end
    end
  end

  def fetch_nested_data(first_key, second_key)
    if data[first_key]
      if data[first_key][second_key]
        return data[first_key][second_key]
      end
    end
    return false
  end

  def add_hometown
    hometown = fetch_nested_data("hometown","name")
    location = fetch_nested_data("location","name")
    if hometown && location
      bio << "Though #{name_pronouns[:name]} lives in #{location}, #{name_pronouns[:pronoun]} hails from #{hometown}."
    elsif hometown
      bio << "#{name_pronouns[:name]} hails from #{hometown}."
    elsif location
      bio << "#{name_pronouns[:name]} lives in #{location}."
    else
      bio << "#{name_pronouns[:name]} is very private about #{name_pronouns[:possesive_pronoun]} location."
    end
  end

  def get_age
    if data["birthday"]
      bd = data["birthday"].split("/").collect {|s| s.to_i }
      birthday = DateTime.new(bd[2], bd[0], bd[1])
      now = Time.now.utc.to_date
      age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
      data[:age] = age
    end
  end

  def get_friend_count
    friend_data = get_fb_data("me?fields=friends&")
    if friend_data["friends"]
      if friend_data["friends"]["summary"]
        if friend_data["friends"]["summary"]["total_count"]
          total = friend_data["friends"]["summary"]["total_count"]
          formatted_total = total.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
        end
      end
    end
  end

  def get_photos
    photo_data = get_fb_data("me/photos?")
    profile_data = get_fb_data("me/picture?redirect=false&")
    pic_url = profile_data["data"]["url"]
  end

end