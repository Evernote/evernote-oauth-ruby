Evernote Sample Sinatra Application for OAuth and Webhook
=========================================================

What is this?
-------------
This is a sample app for OAuth and webhook with a basic usage of Evernote API. You can't test actual webhook in your local environment though, you would see how it works.

What is Webhook?
----------------
If you are building web service and want to track changes of users notes on Evernote, you don't have to poll for them.
You can register to receive notifications every time a user creates or updates a note.  [Learn more about Webhook](http://dev.evernote.com/documentation/cloud/chapters/polling_notification.php).

Setup
-----
- You need a sandbox account.  If you haven't had a Sandbox account yet, you can create one [here](https://sandbox.evernote.com/Registration.action)
- It might be better that you create one or more notes in your Sandbox account before playing around this sample app.
- Set environmental variables below:
    - EN_CONSUMER_KEY: Your API Consumer Key
    - EN_CONSUMER_SECRET: Your API Consumer Secret

    Or you can edit config/evernote.yml
    ```ruby
    consumer_key: YOUR CONSUMER KEY
    consumer_secret: YOUR CONSUMER SECRET
    sandbox: [true or false]
    ```
- Install dependent gems and create database with following commands:
    ```sh
    bundle install
    rake db:migrate
    ```

Run
---
```sh
bundle exec rackup config.ru
```
Then you can access this app: [http://localhost:9292](http://localhost:9292).

References
----------
- Evernote Developers: [http://dev.evernote.com/](http://dev.evernote.com/)
- API Document: [http://dev.evernote.com/documentation/reference/](http://dev.evernote.com/documentation/reference/)
