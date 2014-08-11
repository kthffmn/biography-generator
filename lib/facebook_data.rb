require 'json'
require 'open-uri'
require 'pry'
require 'date'
require 'time'

class FacebookData
  attr_accessor :data, :bio, :pic_url, :name_pronouns
  attr_reader :token, :base_url

  def initialize(token)
    @base_url = "https://graph.facebook.com/v2.0/"
    @token = token
    @data = {}
    @name_pronouns = {}
    @bio = ""
    @pic_url = get_fb_data("me/picture?redirect=false&")["data"]["url"]
  end

  ###########
  # runners #
  ###########

  def self.run(token)
    new(token).get_data.set_data.write_bio
  end

  def set_data
    set_pronouns
    set_names
  end

  def write_bio
    add_locations
    add_education
    add_work
    add_age
    add_friend_count
    add_email_and_website
  end

  ##################
  # shared methods #
  ##################

  def format_array(array)
    if array.length > 1
      array[-1].insert(0, "and ")
    end
    array.join(", ")    
  end

  def fetch_nested_string(hash, first_key, second_key)
    if hash[first_key]
      if hash[first_key][second_key]
        return hash[first_key][second_key]
      end
    end
    return nil
  end

  def fetch_nested_number(hash, first_key, second_key)
    if hash[first_key]
      if hash[first_key][second_key]
        return hash[first_key][second_key].to_i
      end
    end
    return nil
  end

  #########################
  # methods to fetch data #
  #########################

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

  def get_data
    personal_info = get_fb_data("me?")
    personal_info.each do |k, v|
      data[k] = v
    end
  end

  #####################################
  # methods to set names and pronouns #
  #####################################

  def set_pronouns
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

  def set_names
    ["first_name", "name"].each do |key|
      if data[key]
        name_pronouns[key.to_sym] = data[key]
      else
        name_pronouns[key.to_sym] = name_pronouns[:pronoun]
      end
    end
  end

  ################
  # add location #
  ################

  def add_locations
    hometown = fetch_nested_string(data, "hometown", "name")
    location = fetch_nested_string(data, "location", "name")
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

  #################
  # add education #
  #################

  def education_hash
    high_school, high_school_years, colleges, college_years = []
    data["education"].each do |edu|
      if edu["type"]
        if edu["type"] == "High School"
          high_school       << fetch_nested_string(edu, "school", "name")
          high_school_years << fetch_nested_number(edu, "year"  ,"name")
        elsif edu["type"] == "College"
          colleges      << fetch_nested_string(edu, "school","name") 
          college_years << fetch_nested_number(edu, "year"  ,"name")
        end
      end
    end
    edu_hash = {
      :high_school => high_school, 
      :high_school_years => high_school_years, 
      :colleges => colleges, 
      :college_years => college_years
    }
    return edu_hash
  end

  def add_edu_to_bio(hash, type_key, year_key)
    if hash[:type_key].any?
      temp_list = format_array(hash[:type_key])
      bio << "#{name_pronouns[:pronoun]} attended #{temp_list}."
      if edu[:year_key].any?
        bio[-1] = " " # replace period with a space
        bio << "and graduated in #{edu[:year_key].max}."
      end
    end
  end

  def add_education
    edu = education_hash
    edu_types = [:high_school, :college]
    edu_types.each {|type| add_edu_to_bio(edu, type) }
  end

  ############
  # add work #
  ############

  def add_work
    if data["work"]
      employers = []
      data["work"].each do |edu|
        if edu["employer"]
          if edu["employer"]["name"]
            employers << edu["employer"]["name"]
          end
        end
      end
      work_list = format_array(employers)
      bio << "#{name_pronouns[:name]} has worked at #{format_array(work_list)}."
    end
  end

  #########################################
  # add age, friend count, email, website #
  #########################################

  def add_age
    if data["birthday"]
      bd = data["birthday"].split("/").collect {|s| s.to_i }
      birthday = DateTime.new(bd[2], bd[0], bd[1])
      now = Time.now.utc.to_date
      age = now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
      bio << "#{name_pronouns[:name]} is now #{age}."
    end
  end

  def add_friend_count
    friend_data = get_fb_data("me?fields=friends&")
    if friend_data["friends"]
      if friend_data["friends"]["summary"]
        if friend_data["friends"]["summary"]["total_count"]
          total = friend_data["friends"]["summary"]["total_count"]
          formatted_total = total.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
          bio << "#{name_pronouns[:name]} has #{formatted_total} total Facebook friends."
        end
      end
    end
  end

  def add_email_and_website
    ["email", "website"].each do |key|
      if data[key]
        bio << "#{name_pronouns[:possesive_pronoun].capitalize} #{key.to_s} is #{data[key]}."
      end
    end
  end

end