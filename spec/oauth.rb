require 'spec_helper'

describe 'User flow', :type => :feature do

  it 'index page displays link to log in via Facebook' do 
    visit '/'
    expect(page).to have_link("Login through Facebook")
  end

  it "'/callback' url takes a code hash" do
    code = "AQDksEm8P6lM6bfT1eMTocG8B8jH3UHZO14oiNtxZUMPT3oZMupxRYprm8ScdgxZZlATJPJ5OmVYM2W0aZoGpB4obT1CmrzR5OYDyox4EnyKPFQ3moo9Qq_vTyO3lvkgig_2BcBOYAK50voc--T3_Iqdhzeo8-ANbR5G7i22cV_JJU4W0LED7pn7pHeY26jL9PJTOsd7MIxFg9-Rw2CO7ACXzKDmslIj3J4Wh-Is2RrKkbUWNaTbRyMXPH23LQNtsOoIDJ2aQ5sfjiMNzBbrXtC_LnMPEKyRUKxNeM_gKcNBQD0yLLT98NL5nw3sa2Ff6LVKs_HFLg4lFnxQIlWvO1iw"
    visit "/callback?code=#{code}"
    page.save_and_open_page
  end

  xit "result page displays user bio" do

  end

  xit "result page displays user picture in with the id 'user-picture'" do

  end

  it "result page defaults to bio as 'Sorry for the inconvenience, but a generated biography is unavailable.'" do
    visit '/result'
    expect(page).to have_content("Sorry for the inconvenience, but a generated biography is unavailable.")
  end

  it "result page defaults the user picture to a 50x50 placekitten" do
    visit '/result'
    expect(page.find('#user-picture')['src']).to have_content("http://placekitten.com/g/50/50")
  end
end