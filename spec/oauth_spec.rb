require_relative './spec_helper'

describe 'User flow', :type => :feature do

  describe "home page" do
    before :each do
      visit '/'
    end
    it "links to log in via Facebook has an id of 'facebook-login'" do 
      expect(page).to have_link("Login through Facebook")
      expect(page.all('#facebook-login').count).to eq(1)
      expect(page.all('#facebook-login')[0].text).to eq("Login through Facebook")
    end
    it "has the correct url for the first step of logging in via Facebook" do 
      url = page.find('#facebook-login')['href']
      expect(url).to have_content("https://www.facebook.com/dialog/oauth?client_id=")
      expect(url).to have_content("&redirect_uri=")
      expect(url).to have_content("&scope=")
      # scopes
      desired_scopes = ["email","user_birthday","user_friends","user_photos","user_education_history","user_hometown","user_location","user_website","user_work_history"]
      desired_scopes.each do |scope|
        expect(url).to have_content(scope)
      end
    end
  end

  describe "callback" do
    before :each do
      visit "/callback?code=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end
    it "accepts a code in the params and eventually redirects to '/results'" do
      expect(page).to have_content('Generated Biography')
    end
    it "sets each session's 'access_token' by querying Facebook for a token using the code from params (the access_token should default to 'unrecognized_code')" do
      visit "/callback?code=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      expect(page.get_rack_session_key('access_token')).to_not be_nil
      expect(page.get_rack_session_key('access_token')).to eq('unrecognized_code')
    end
  end

  describe "result" do
    it "defaults to bio as 'Sorry for the inconvenience...'" do
      visit '/result'
      expect(page).to have_content("Sorry for the inconvenience, but a generated biography is unavailable.")
    end
    it "defaults the user picture to a 50x50 placekitten" do
      visit '/result'
      expect(page.find('#user-picture')['src']).to have_content("http://placekitten.com/g/50/50")
    end
    it "takes session's 'access_token' and uses it to obtain information on the user" do
      token = "Q0FBQ0VkRW9zZTBjQkFNa2ZLN3Z1bVVLOWNqNXF1d2M4YXdrWkFaQ3Ixdm5R\nY3VUN0FiR1NMVlVVaVlSMEg3NUVONG4zU0laQmpRZmhpRW5aQndROVRjajla\nQ3NSd1R5dXNQVHVueG9NOTBsd3lWRWZaQ3lFWkFaQ2c2aTI0QlFQQ3lWRGVr\nd21jVTZQTGoyWUFaQ2F3V3J6aldNa3VYNkFjenBFTlVjTEg3TjlicWNYYXoy\nbTNPeHhKV2w1VUlmV3o1VWNwQzhmMjBmNGNIVEhmR21aQVpDckRuYQ==\n"
      page.set_rack_session("access_token" => Base64.decode64(token))
      visit '/result'
      expect(page).to have_content("Katie Hoffman")
      expect(page).to have_content("Brooklyn, New York")
      expect(page).to have_content("Denver, Colorado")
      expect(page).to have_content("ktahoffman@gmail.com")
      expect(page).to have_content("http://kthffmn.com")
      expect(page).to have_content("Columbia University")
    end
  end
end