Evernote OAuth / Thrift API client library for Ruby
===================================================
- Evernote OAuth version 0.1.4

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
### OAuth ###
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
token = access_token.token
client = EvernoteOAuth::Client.new(token: token)
note_store = client.note_store
notebooks = note_store.listNotebooks(token)
```

### UserStore ###
Once you acquire token, you can use UserStore. For example, if you want to call UserStore.getUser:
```ruby
user_store = EvernoteOAuth::Client.new(token: token).user_store
user_store.getUser(token)
```
You can also omit authenticationToken in the arguments of UserStore functions:
```ruby
user_store.getUser
```

### NoteStore ###
If you want to call NoteStore.listNotebooks:
```ruby
note_store = EvernoteOAuth::Client.new(token: token).note_store
note_store.listNotebooks(token)
```
You can also omit authenticationToken in the arguments of NoteStore functions:
```ruby
note_store.listNotebooks
```

### NoteStore for linked notebooks ###
If you want to get tags for linked notebooks:
```ruby
linked_notebook = note_store.listLinkedNotebooks.first # any notebook
shared_note_store = client.shared_note_store(linked_notebook)
stoken = shared_note_store.token
shared_notebook = shared_note_store.getSharedNotebookByAuth(stoken)
shared_note_store.listTagsByNotebook(stoken, shared_notebook.notebookGuid)
```
You can also omit authenticationToken in the arguments of NoteStore functions:
```ruby
shared_notebook = shared_note_store.getSharedNotebookByAuth
shared_note_store.listTagsByNotebook(shared_notebook.notebookGuid)
```

### Method Chaining ###
You can chain methods:
```ruby
note_store.findNotes(Evernote::EDAM::NoteStore::NoteFilter.new, 0, 10).first.tags.first.parent
 => [<Evernote::EDAM::Type::Tag guid:"xxxxx", name:"sample", updateSequenceNum:100>]
```
Here are the additional methods for each types:

- Evernote::EDAM::NoteStore::NoteList
  - notes
- Evernote::EDAM::NoteStore::NoteMetadata
  - tags
- Evernote::EDAM::NoteStore::NotesMetadataList
  - notes
- Evernote::EDAM::NoteStore::SyncChunk
  - notes, notebooks, tags, searches, resources, linkedNotebooks
- Evernote::EDAM::Type::Note
  - notebook, tags
- Evernote::EDAM::Type::Resource
  - note: needs hash argument
      - with_constant: boolean
      - with_resources_data: boolean
      - with_resources_recognition: boolean
      - with_resources_alternate_data: boolean
- Evernote::EDAM::Type::SharedNotebook
  - notebook
- Evernote::EDAM::Type::Tag
  - parent

Notes: Those methods call thrift API internally.  The result will be cached in the object so that the second method call wouldn't thrift API again.

### Image Adding ###
Additional method is defined in Note to be easily added an image:
```ruby
note = Evernote::EDAM::Type::Note.new(
  title: 'Note',
  tagNames: ['Evernote API Sample']
)

filename = "enlogo.png"
image = File.open(filename, "rb") { |io| io.read }
hexdigest = note.add_resource(filename, image, 'image/png')
```
You can use hexdigest within ENXML:
```xml
<en-media type="image/png" hash="#{hexdigest}"/>
```

References
----------
- Evernote Developers: http://dev.evernote.com/
- API Document: http://dev.evernote.com/documentation/reference/
