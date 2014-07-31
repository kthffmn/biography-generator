class FacebookData
  attr_accessor :total_friends, :female_friends, :male_friends, 
                :joiners, :lowest_id, :highest_id, :birthday_info
  attr_reader   :token, :graph

  def initialize(token)
    @token = token
    @graph = Koala::Facebook::API.new(token)
    @birthday_info = []

    @joiners = {first_on_fb: {}, last_on_fb: {}}

    @lowest_id = Float::INFINITY
    @highest_id = 0

    @total_friends = 0
    @male_friends = 0
    @female_friends = 0
  end

  def friends
    graph.get_connections("me", "friends")
  end

  def fetch_data(id)
    JSON.load(open("https://graph.facebook.com/user?id=#{id}&access_token=#{token}"))
  end

  def update_birthday_hash(data)
    if data["birthday"]
      birthday_info << {:first_name => data["first_name"], :last_name => data["last_name"], :id => data["id"], :birthday => data["birthday"] }
    end
  end

  def update_first_and_last_friends_on_fb(data)
    id = data["id"].to_i
    if id < lowest_id
      joiners[:first_on_fb][:name] = data["name"]
      joiners[:first_on_fb][:id] = id
      self.lowest_id = id
    end
    if id > highest_id
      joiners[:last_on_fb][:name] = data["name"]
      joiners[:last_on_fb][:id] = id
      self.highest_id = id
    end
  end

  def update_gender_ratios(data)
    self.total_friends += 1
    if data["gender"] == "male"
      self.male_friends += 1
    elsif data["gender"] == "female"
      self.female_friends += 1
    end
  end

  def main
    friends.each_with_index do |friend_hash, i|
      data = fetch_data(friend_hash["id"])
      update_birthday_hash(data)
      update_first_and_last_friends_on_fb(data)
      update_gender_ratios(data)
    end
    {:joiners => joiners, 
     :friends => {
      :total_friends => total_friends, 
      :male_friends => male_friends,
      :female_friends => female_friends
      },
    :friends_birthdays => birthday_info
    }
  end

end

# 