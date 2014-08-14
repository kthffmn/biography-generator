require 'spec_helper'

describe 'user actions', :type => :feature do

  it "displays index.erb when at root url and not failure page" do
    visit '/'
    page.save_and_open_page
    expect(page).to_not have_content('error')
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