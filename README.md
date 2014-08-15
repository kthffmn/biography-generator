---
tags: oauth, api, sinatra, sessions
languages: ruby
resources: 4
---

# Facebook Data Miner

## Objectives
* Manually build an OAuth login flow
* Use Faebook's Graph API fetch as much information on the user as possible

## Instructions
1. Interact with [Facebook's Graph API sandbox](https://developers.facebook.com/tools/explorer/). What data did Facebook choose to expose and what data it choose to hide? Now that you've taken a look at what info is exposed, read about [OAuth](http://en.wikipedia.org/wiki/OAuth).

2. This lab uses Capybara, Capybara-Webkit, and Dotenv gems. Run `gem install capybara` and `gem install dotenv` if they're not already installed on your machine. Make sure you run `brew install qt` before running `gem install capybara-webkit` as it relies on [QT](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit). Once your environment has each gem, go ahead and `bundle install`.

3. Make a new app on [Facebook's Developer interface](https://developers.facebook.com/apps). In your Facebook app's Advanced Settings page, you'll need to specify the callback URI. Since this lab uses Rackup (localhost:9292), specify the callback URI as `http://localhost:9292/callback`. 
  * On the Facebook interface for your app, make sure it has access to the following scopes:
    * email
    * user_birthday
    * user_friends
    * user_photos
    * user_education_history
    * user_hometown
    * user_location
    * user_website
    * user_work_history


4. To hide your app's key and secret, store the values in a new file called `.env`. This file will be in the root folder of the app. Set your environmental variables in it like this:
  ```text
  APP_SECRET=SECRET-GOES-HERE
  APP_ID=APP-ID-GOES-HERE
  REDIRECT_URI=http://localhost:9292/callback
  ```
5. In `app.rb`, change the value of @facebook_url so that it links to the first URL of Facebook's OAuth process. Refer to the [Facebook Login Flow](https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flo) for help. Make sure that the url specifies each scope on the list of scopes above.

6. In `app.rb`, capture the code that Facebook returns to your app's callback URI and use it to fetch an access token for a user.

7. Still in `app.rb`, [enable sessions](http://www.sinatrarb.com/intro.html#Using%20Sessions). Query Facebook for a token using the code from Step 6 and your app's secret and save this access token to a session. 

8. Pass the class `FacebookData`, which lives in `lib/facebook_data.rb`, the access token from [step 7](#instructions). Build out this class to fetch the user's data via Facebook's Graph API and use it to generate a biography for each user. 

9. Display this biography in `views/result.erb` page.

* Note: Because this is a test app, your app's key and secret will only work with your account. To make them work with other accounts, you must submit your tokens for approval so don't worry too much if your app doesn't work for other people's accounts.

## Resources
* [Facebook Dev Docs](https://developers.facebook.com/docs) - [Graph API](https://developers.facebook.com/tools/explorer/)
* [Wikipedia](http://en.wikipedia.org/) - [OAuth](http://en.wikipedia.org/wiki/OAuth)
* [Facebook Dev Docs](https://developers.facebook.com/docs) - [Manually Build a Login Flow](https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.1)
* [Sinatra Docs](http://www.sinatrarb.com/) - [Enabling Sessions](http://www.sinatrarb.com/intro.html#Using%20Sessions)
