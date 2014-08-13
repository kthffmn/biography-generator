require_relative 'spec_helper'

describe 'user actions', :type => :feature do

  it 'displays text about logging in via Facebook' do
    visit '/'
    expect(page).to have_content('Login through Facebook')
  end
  
  it 'displays link to log in' do 
    visit '/'
    expect(page).to have_link('Login through Facebook')
  end

  it 'directs users to a bio page' do 
    visit '/'
    click_link 'Login through Facebook'
    expect(page).to have_content 'Generated Biography'
  end

end