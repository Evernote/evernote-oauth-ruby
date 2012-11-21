Evernote Sample Usage of API for Ruby on Rails
==============================================
This is a sample application of Ruby on Rails with evernote_oauth gem and evernote-omniauth gem.

Setup
-----
- Set environmental variables below:
    - EN_CONSUMER_KEY: Your API Consumer Key
    - EN_CONSUMER_SECRET: Your API Consumer Secret
- You need a sandbox account.  If you haven't had a Sandbox account yet, you can create one [here](https://sandbox.evernote.com/Registration.action)
- `bundle install`
    - If you don't have bundler gem, you can install it with `gem install bundler`.

How to use?
-----------
You can start rails server with `rails start`.  Once the rails server starts, you can access `http://localhost:3000` and see the application.

This sample application gives you sample code on how to use each API.  When you log in first, it runs as a reference mode which just shows how to write code and API document.  If you want to run the API call and see actual return value, you can click the "Allow actual API call" link on the top of root page.

Methods with "[UNAVAILABLE]" are only available to Evernote's internal applications or deprecated.
