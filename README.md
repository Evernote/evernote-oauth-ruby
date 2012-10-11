Evernote OAuth / Thrift API client library for Ruby
===================================================
- Evernote OAuth version 0.1.0

Install the gem
---------------
gem install evernote_oauth

Prerequisites
-------------
In order to use the code in this SDK, you need to obtain an API key from http://dev.evernote.com/documentation/cloud. You'll also find full API documentation on that page.

In order to run the sample code, you need a user account on the sandbox service where you will do your development. Sign up for an account at https://sandbox.evernote.com/Registration.action 

In order to run the client client sample code, you need a developer token. Get one at https://sandbox.evernote.com/api/DeveloperToken.action

Setup
-----
Put your API keys in the config/evernote.yml
```ruby
development:
  consumer_key: YOUR CONSUMER KEY
  consumer_secret: YOUR CONSUMER SECRET
  sandbox: [true or false]
```
Or you can just pass those information when you create an instance of the client
```ruby
client = EvernoteOAuth::Client.new(
  consumer_key: YOUR CONSUMER KEY,
  consumer_secret: YOUR CONSUMER SECRET,
  sandbox: [true or false]
)
```

Usage
-----
```ruby
client = EvernoteOAuth::Client.new
request_token = client.request_token(:oauth_callback => 'YOUR CALLBACK URL')
request_token.authorize_url
 => https://sandbox.evernote.com/OAuth.action?oauth_token=OAUTH_TOKEN
```
To obtain the access token
```ruby
access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
```
Now you can make other API calls
```ruby
client = EvernoteOAuth::Client.new(token: access_token.token)
note_store = client.note_store
notebooks = note_store.listNotebooks(access_token.token)
```

References
----------
- Evernote Developers: http://dev.evernote.com/
- API Document: http://dev.evernote.com/documentation/reference/
