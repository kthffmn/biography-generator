---
tags: oauth, api, WIP
languages: ruby
resources: 1
---
# Facebook Data Miner

## Objectives
* Manually build a OAuth login flow
* Get familiar with Faebook's Graph API
* Use the token obtained from the login flow to fetch as much information on the user as possible

## Instructions
1. Visit `https://developers.facebook.com/tools/explorer/` and play around with Facebook's Graph API. What data is exposed to the API and what data isn't?

2. This lab uses Capybara, Capybara-Webkit, and Dotenv gems. Run `gem install capybara` and `gem install dotenv` if they're not already installed on your machine. Run `brew install qt` before running `gem install capybara-webkit`. Once your environment has each gem, go ahead and `bundle install`.

3. Make a new app on Facebook's API page. In your Facebook app's Advanced Settings page, you'll need to specify the callback URI. Since this lab uses Rackup (localhost:9292), specify the callback URI as `http://localhost:9292/callback`. 
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


4. To hide your app's key and secret, store the values in a new file called `.env` from the root folder of this app. 
  ```
  touch .env
  subl .env
  ```

  `.env`
  ```text
  APP_SECRET=SECRET-GOES-HERE
  APP_ID=APP-ID-GOES-HERE
  REDIRECT_URI=http://localhost:9292/callback
  ```

5. Change the value of @facebook_url in `app.rb` so that it links to the first URL of Facebook's OAuth process. Refer to the Facebook Login Flow link below for help. Make sure that the url specifies each scope on the list of scopes above.

6. 

## Resources
* [Facebook Dev Docs](https://developers.facebook.com/docs) - [Manually Build a Login Flow](https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.1)