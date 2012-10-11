#
# A simple Evernote API demo script that lists all notebooks in the user's
# account and creates a simple test note in the default notebook.
#
# Before running this sample, you must:
# - fill in your Evernote developer token.
# - install evernote-thrift gem.
#
# To run (Unix):
#   ruby EDAMTest.rb
#

require "digest/md5"
require 'evernote_oauth'

# Real applications authenticate with Evernote using OAuth, but for the
# purpose of exploring the API, you can get a developer token that allows
# you to access your own Evernote account. To get a developer token, visit
# https://sandbox.evernote.com/api/DeveloperToken.action
authToken = "your developer token"

if authToken == "your developer token"
  puts "Please fill in your developer token"
  puts "To get a developer token, visit https://sandbox.evernote.com/api/DeveloperToken.action"
  exit(1)
end

# Initial development is performed on our sandbox server. To use the production
# service, add "sandbox: false" option and replace your
# developer token above with a token from
# https://www.evernote.com/api/DeveloperToken.action
client = EvernoteOAuth::Client.new(token: authToken)

# List all of the notebooks in the user's account
note_store =  client.note_store
notebooks = note_store.listNotebooks(authToken)
puts "Found #{notebooks.size} notebooks:"
defaultNotebook = notebooks.first
notebooks.each do |notebook|
  puts "  * #{notebook.name}"
end

puts
puts "Creating a new note in the default notebook: #{defaultNotebook.name}"
puts

# To create a new note, simply create a new Note object and fill in
# attributes such as the note's title.
note = Evernote::EDAM::Type::Note.new
note.title = "Test note from EDAMTest.rb"

# To include an attachment such as an image in a note, first create a Resource
# for the attachment. At a minimum, the Resource contains the binary attachment
# data, an MD5 hash of the binary data, and the attachment MIME type. It can also
#/ include attributes such as filename and location.
filename = "enlogo.png"
image = File.open(filename, "rb") { |io| io.read }
hashFunc = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hashFunc.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

# Now, add the new Resource to the note's list of resources
note.resources = [ resource ]

# To display the Resource as part of the note's content, include an <en-media>
# tag in the note's ENML content. The en-media tag identifies the corresponding
# Resource using the MD5 hash.
hashHex = hashFunc.hexdigest(image)

# The content of an Evernote note is represented using Evernote Markup Language
# (ENML). The full ENML specification can be found in the Evernote API Overview
# at http://dev.evernote.com/documentation/cloud/chapters/ENML.php
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Here is the Evernote logo:<br/>
  <en-media type="image/png" hash="#{hashHex}"/>
</en-note>
EOF

# Finally, send the new note to Evernote using the createNote method
# The new Note object that is returned will contain server-generated
# attributes such as the new note's unique GUID.
createdNote = note_store.createNote(authToken, note)

puts "Successfully created a new note with GUID: #{createdNote.guid}"
