---
tags: oauth, api
languages: ruby
resources: 1
---
# Facebook Data Miner

## Objectives
* Manually build a OAuth login flow
* Use the token obtained from the login flow to fetch information on the user
* Get familiar with Faebook's Graph API

## Instructions
1. This lab uses Caybara, Capybara-Webkit, Koala, and Dotenv gems. Run `brew install qt` before running `gem install capybara-webkit`. Once your environment has each gem, run `bundle install`.

2. Command line:
  ```
  git clone https://github.com/kthffmn/facebook-data-miner.git
  cd facebook-data-miner
  bundle install
  touch .env
  subl .env
  ```
  * Make a new app on Facebook's API page. In your Facebook app's Advanced Settings page, you'll need to specify the callback URI. Since this lab uses Rackup, specify the callback URI as `http://localhost:9292/callback`. 
  * On the Facebook interface for you app, make sure it has access to the following scopes:
    * email
    * user_birthday
    * user_friends
    * user_photos
    * user_education_history
    * user_hometown
    * user_location
    * user_website
    * user_work_history
  * Alter the `.env` file to reflect it:
  ```text
  APP_SECRET=SECRET-GOES-HERE
  APP_ID=APP-ID-GOES-HERE
  REDIRECT_URI=http://localhost:9292/callback
  ```
  Command line:
  ```
3. Change the value of @facebook_url in `app.rb` so that it links to the first URL that of Facebook's OAuth process. Refer to the Facebook Login Flow link below for help. Make sure that the url specifies each scope on the list above.
4. 

## Resources
* [Facebook Dev Docs](https://developers.facebook.com/docs) - [Manually Build a Login Flow](https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.1)