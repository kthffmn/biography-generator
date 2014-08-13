require_relative 'spec_helper'

describe 'user actions', :type => :feature do

  it "H1 header displays text 'Short Bio Generator'" do
    visit '/'
    page.all("h1").count.should eql(1)
    expect(page).to have_content('Short Bio Generator')
  end

  it "encourages users to click on link" do
    visit '/'
    binding.pry
    expect(page).to have_content('Please click')
  end

  it 'displays link to log in via Facebook' do 
    visit '/'
    expect(page).to find_link("Login through Facebook")
  end

  it 'directs users to a bio page' do 
    visit '/'
    click_link('Login through Facebook')
    expect(page).to have_content 'Generated Biography'
  end

end