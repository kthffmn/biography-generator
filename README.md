# Facebook Data Miner

## Getting Started

Command line:
```
git clone https://github.com/kthffmn/facebook-data-miner.git
cd facebook-data-miner
bundle install
rackup
touch .env
subl .env
```
Make a new app on Facebook's API page. Modify the `.env` file to reflect it:
```text
APP_SECRET=SECRET-GOES-HERE
APP_ID=APP-ID-GOES-HERE
REDIRECT_URI=http://url+goes+here.com/callback
```
Command line:
```
rackup
```
Browser
```
http://localhost:9292/
```
