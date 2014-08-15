require 'spec_helper'

describe 'Login user', :type => :feature do

  it 'displays link to log in via Facebook' do 
    visit '/'
    expect(page).to have_link("Login through Facebook")
  end

  it "result page displays user bio" do
    @pic_url = "spongebob.png"
    @bio = "SpongeBob SquarePants is a yellow sponge who wears square pants, thus the name. He lives in a pineapple at 124 Conch Street with his pet snail, Gary, in the underwater city of Bikini Bottom."
    @token = "2387f9vdweersdsf9s0vss7sddddd7sdfwerwuf9sd0vusdapeoe09q8w0kjc32490slfjdfsdf"
    erb :result
    expect(page).to have_content(@bio)
  end

  it "result page displays user picture in with the id 'user-picture'" do
    @pic_url = "spongebob.png"
    @bio = "SpongeBob SquarePants is a yellow sponge who wears square pants, thus the name. He lives in a pineapple at 124 Conch Street with his pet snail, Gary, in the underwater city of Bikini Bottom."
    @token = "2387f9vdweersdsf9s0vss7sddddd7sdfwerwuf9sd0vusdapeoe09q8w0kjc32490slfjdfsdf"
    erb :result
    expect(page.find('#user-picture')['src']).to have_content(@pic_url)
  end

  it "result page defaults to bio as 'invalid token' and user picture as a 50x50 placekitten" do
    visit '/result'
    expect(page).to have_content("Invalid token")
    expect(page.find('#user-picture')['src']).to have_content("http://placekitten.com/g/50/50")
  end
end