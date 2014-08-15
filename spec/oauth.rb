require 'spec_helper'

describe 'User flow', :type => :feature do

  it 'index page displays correct text for link to log in via Facebook' do 
    visit '/'
    expect(page).to have_link("Login through Facebook")
  end

  it "index page's link to log in via Facebook has an id of 'facebook-login'" do 
    visit '/'
    expect(page.all('#facebook-login').count).to eq(1)
  end

  it 'index page displays correct url for link to log in via Facebook' do 
    visit '/'
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

  it "result page defaults to bio as 'Sorry for the inconvenience'" do
    visit '/result'
    expect(page).to have_content("Sorry for the inconvenience, but a generated biography is unavailable.")
  end

  it "result page defaults the user picture to a 50x50 placekitten" do
    visit '/result'
    expect(page.find('#user-picture')['src']).to have_content("http://placekitten.com/g/50/50")
  end
end