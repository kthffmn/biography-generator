require "koala"
require "json"
require 'open-uri'
require "pry"

class FacebookData
  attr_accessor :total_friends, :female_friends, :male_friends, 
                :joiners, :lowest_id, :highest_id
  attr_reader   :token, :graph

  def initialize(token)
    @token = token
    @graph = Koala::Facebook::API.new(token)
    @joiners = {first_on_fb: {}, last_on_fb: {}}
    @lowest_id = Float::INFINITY
    @total_friends, @male_friends, @female_friends, @highest_id = 0
  end

  def friends
    graph.get_connections("me", "friends")
  end

  def fetch_data(id)
    JSON.load(open("https://graph.facebook.com/user?id=#{id}&access_token=#{token}"))
  end

  def update_birthday_hash(data)
    if data["birthday"]
      birthday_info << {:name => data["name"], :id => data["id"], :birthday => data["birthday"] }
    end
  end

  def update_first_and_last_friends_on_fb(data)
    numerical_id = data["id"].to_s
    if numerical_id < lowest_id_num
      joiners[:first_on_fb][:name] = data["name"]
      joiners[:first_on_fb][:id] = numerical_id
      @lowest_id_num = numerical_id
    end
    if numerical_id > highest_id_num
      joiners[:last_on_fb][:name] = data["name"]
      joiners[:last_on_fb][:id] = numerical_id
      @highest_id_num = numerical_id
    end
  end

  def update_gender_ratios(data)
    total_friends += 1
    if data["gender"] == "male"
      male += 1
    elsif data["gender"] == "female"
      female += 1
    end
  end

  def main
    friends.each_with_index do |friend_hash, i|
      data = fetch_data(friend_hash["id"])
      update_birthday_hash(data)
      update_first_and_last_friends_on_fb(data)
      update_gender_ratios(data)
    end
  end

end

my_friends = FacebookData.new("")
my_friends.