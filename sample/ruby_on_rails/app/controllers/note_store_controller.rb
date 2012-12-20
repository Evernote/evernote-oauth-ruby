class NoteStoreController < EvernoteController

  private
  def authenticateToSharedNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
share_key = note_store.shareNote(created_note.guid)

note_store.authenticateToSharedNote(created_note.guid, share_key)
    CODE
  end

  def authenticateToSharedNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
linked_notebooks = note_store.listLinkedNotebooks

linked_notebook = linked_notebooks.first
share_key = linked_notebook.shareKey
note_store.authenticateToSharedNotebook(share_key)
    CODE
  end

  def createLinkedNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
user_store = client.user_store

notebook = Evernote::EDAM::Type::Notebook.new
notebook.name = "Notebook #{Time.now.to_i}"
created_notebook = note_store.createNotebook(notebook)

shared_notebook = Evernote::EDAM::Type::SharedNotebook.new
shared_notebook.email = '#{params[:email]}'
shared_notebook.notebookGuid = created_notebook.guid
created_shared_notebook = note_store.createSharedNotebook(shared_notebook)

user = user_store.getUser

linked_notebook = Evernote::EDAM::Type::LinkedNotebook.new
linked_notebook.shareName = "Linked Notebook"
linked_notebook.username = user.username
linked_notebook.shareKey = created_shared_notebook.shareKey
linked_notebook.shardId = user.shardId

note_store.createLinkedNotebook(linked_notebook)
    CODE
  end

  def createSharedNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
user_store = client.user_store

notebook = Evernote::EDAM::Type::Notebook.new
notebook.name = "Notebook #{Time.now.to_i}"

created_notebook = note_store.createNotebook(notebook)

shared_notebook = Evernote::EDAM::Type::SharedNotebook.new
shared_notebook.email = '#{params[:email]}'
shared_notebook.notebookGuid = created_notebook.guid

note_store.createSharedNotebook(shared_notebook)
    CODE
  end

  def updateSharedNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
linked_notebooks = note_store.listLinkedNotebooks

linked_notebook = linked_notebooks.first
shared_note_store = client.shared_note_store(linked_notebook)
shared_notebook = shared_note_store.getSharedNotebookByAuth

note_store.updateSharedNotebook(shared_notebook)
    CODE
  end

  def copyNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.copyNote(created_note.guid, created_note.notebookGuid)
    CODE
  end

  def createNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

note_store.createNote(note)
    CODE
  end

  def createNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

notebook = Evernote::EDAM::Type::Notebook.new
notebook.name = "Notebook #{Time.now.to_i}"

note_store.createNotebook(notebook)
    CODE
  end

  def createSearch
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

saved_search = Evernote::EDAM::Type::SavedSearch.new
saved_search.name = "SavedSearch #{Time.now.to_i}"
saved_search.query = "created:20070704"
saved_search.format = Evernote::EDAM::Type::QueryFormat::USER

note_store.createSearch(saved_search)
    CODE
  end

  def createTag
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

tag = Evernote::EDAM::Type::Tag.new
tag.name = "Evernote API Sample #{Time.now.to_i}"

note_store.createTag(tag)
    CODE
  end

  def deleteNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.deleteNote(created_note.guid)
    CODE
  end

  def emailNote
    @note = 'This function is not available to third party applications. Calls will result in an EDAMUserException with the error code PERMISSION_DENIED.'
  end

  def expungeInactiveNotes; end
  def expungeLinkedNotebook; end
  def expungeNote; end
  def expungeNotebook; end
  def expungeNotes; end
  def expungeSearch; end
  def expungeSharedNotebooks; end
  def expungeTag; end

  def findNoteCounts
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
note_store.findNoteCounts(note_filter, false)
    CODE
  end

  def findNoteOffset
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
note_store.findNoteOffset(note_filter, created_note.guid)
    CODE
  end

  def findNotesMetadata
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
notes_metadata_result_spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
note_store.findNotesMetadata(note_filter, 0, 100, notes_metadata_result_spec)
    CODE
  end

  def findNotes
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_filter = Evernote::EDAM::NoteStore::NoteFilter.new
note_store.findNotes(note_filter, 0, 10)
    CODE
  end

  def findRelated
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

related_query = Evernote::EDAM::NoteStore::RelatedQuery.new
related_query.plainText = 'content'
related_result_spec = Evernote::EDAM::NoteStore::RelatedResultSpec.new
related_result_spec.maxNotes = 10
related_result_spec.maxNotebooks = 10
related_result_spec.maxTags = 10
note_store.findRelated(related_query, related_result_spec)
    CODE
  end

  def getDefaultNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.getDefaultNotebook
    CODE
  end

  def getFilteredSyncChunk
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

sync_chunk_filter = Evernote::EDAM::NoteStore::SyncChunkFilter.new
sync_chunk_filter.includeNotes = true
note_store.getFilteredSyncChunk(0, 1, sync_chunk_filter)
    CODE
  end

  def getLinkedNotebookSyncChunk
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
linked_notebooks = note_store.listLinkedNotebooks

linked_notebook = linked_notebooks.first
shared_note_store = client.shared_note_store(linked_notebook)

shared_note_store.getLinkedNotebookSyncChunk(authtoken, linked_notebook, 0, 1, true)
    CODE
  end

  def getLinkedNotebookSyncState
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
linked_notebooks = note_store.listLinkedNotebooks

linked_notebook = linked_notebooks.first
shared_note_store = client.shared_note_store(linked_notebook)

shared_note_store.getLinkedNotebookSyncState(authtoken, linked_notebook)
    CODE
  end

  def getNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.getNote(created_note.guid, true, false, false, false)
    CODE
  end

  def getNoteApplicationData
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]
application_data = Evernote::EDAM::Type::LazyMap.new
application_data.fullMap = {'key' => 'value'}
note_attributes = Evernote::EDAM::Type::NoteAttributes.new
note_attributes.applicationData = application_data
note.attributes = note_attributes

created_note = note_store.createNote(note)

note_store.getNoteApplicationData(created_note.guid)
    CODE
  end

  def getNoteApplicationDataEntry
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]
application_data = Evernote::EDAM::Type::LazyMap.new
application_data.fullMap = {'key' => 'value'}
note_attributes = Evernote::EDAM::Type::NoteAttributes.new
note_attributes.applicationData = application_data
note.attributes = note_attributes

created_note = note_store.createNote(note)

note_store.getNoteApplicationDataEntry(created_note.guid, 'key')
    CODE
  end

  def getNoteContent
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.getNoteContent(created_note.guid)
    CODE
  end

  def getNoteSearchText
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.getNoteSearchText(created_note.guid, false, true)
    CODE
  end

  def getNoteTagNames
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.getNoteTagNames(created_note.guid)
    CODE
  end

  def getNoteVersion
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note Version 1"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Version 1</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

created_note.title = "Note Version 2"
created_note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Version 2</en-note>
EOF

updated_note = note_store.updateNote(created_note)

note_store.getNoteVersion(updated_note.guid, created_note.updateSequenceNum, false, false, false)
    CODE
  end

  def getNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

notebook = Evernote::EDAM::Type::Notebook.new
notebook.name = "Notebook #{Time.now.to_i}"

created_notebook = note_store.createNotebook(notebook)

note_store.getNotebook(created_notebook.guid)
    CODE
  end

  def getPublicNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
note_store = client.note_store

public_user_info = user_store.getPublicUserInfo('evernotedev')

note_store.getPublicNotebook(public_user_info.userId, 'cooking_notes')
    CODE
  end

  def getResource
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResource(resource_guid, false, false, false, false)
    CODE
  end

  def getResourceAlternateData
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

alternate_filename = "rails.png"
alternate_image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }

alternate_data = Evernote::EDAM::Type::Data.new
alternate_data.size = alternate_image.size
alternate_data.bodyHash = hash_func.digest(alternate_image)
alternate_data.body = alternate_image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.alternateData = alternate_data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceAlternateData(resource_guid)
    CODE
  end

  def getResourceApplicationData
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

application_data = Evernote::EDAM::Type::LazyMap.new
application_data.fullMap = {'key' => 'value'}
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.applicationData = application_data
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceApplicationData(resource_guid)
    CODE
  end

  def getResourceApplicationDataEntry
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.fileName = filename

application_data = Evernote::EDAM::Type::LazyMap.new
application_data.fullMap = {'key' => 'value'}
resource_attributes.applicationData = application_data
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceApplicationDataEntry(resource_guid, 'key')
    CODE
  end

  def getResourceAttributes
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.fileName = filename
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceAttributes(resource_guid)
    CODE
  end

  def getResourceByHash
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
body_hash = hash_func.digest(image)
data.bodyHash = body_hash
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.fileName = filename
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceByHash(created_note.guid, body_hash, false, false, false)
    CODE
  end

  def getResourceData
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.fileName = filename
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceData(resource_guid)
    CODE
  end

  def getResourceRecognition
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.fileName = filename
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceRecognition(resource_guid)
    CODE
  end

  def getResourceSearchText
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "evernote_logo_center.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource_attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource_attributes.fileName = filename
resource.attributes = resource_attributes

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.getResourceSearchText(resource_guid)
    CODE
  end

  def getSearch
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

saved_search = Evernote::EDAM::Type::SavedSearch.new
saved_search.name = "SavedSearch #{Time.now.to_i}"
saved_search.query = "created:20070704"
saved_search.format = Evernote::EDAM::Type::QueryFormat::USER

created_search = note_store.createSearch(saved_search)

note_store.getSearch(created_search.guid)
    CODE
  end

  def getSharedNotebookByAuth
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store
linked_notebooks = note_store.listLinkedNotebooks

linked_notebook = linked_notebooks.first
shared_note_store = client.shared_note_store(linked_notebook)

shared_note_store.getSharedNotebookByAuth
    CODE
  end

  def getSyncChunk
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.getSyncChunk(0, 1, true)
    CODE
  end

  def getSyncState
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.getSyncState
    CODE
  end

  def getSyncStateWithMetrics
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

client_usage_metrics = Evernote::EDAM::NoteStore::ClientUsageMetrics.new
client_usage_metrics.sessions = 0

note_store.getSyncStateWithMetrics(client_usage_metrics)
    CODE
  end

  def getTag
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

tag = Evernote::EDAM::Type::Tag.new
tag.name = "Evernote API Sample #{Time.now.to_i}"

created_tag = note_store.createTag(tag)

note_store.getTag(created_tag.guid)
    CODE
  end

  def listLinkedNotebooks
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.listLinkedNotebooks
    CODE
  end

  def listNotebooks
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.listNotebooks
    CODE
  end

  def listNoteVersions
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note Version 1"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Version 1</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

created_note.title = "Note Version 2"
created_note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Version 2</en-note>
EOF

updated_note = note_store.updateNote(created_note)

note_store.listNoteVersions(updated_note.guid)
    CODE
  end

  def listSearches
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.listSearches
    CODE
  end

  def listTags
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.listTags
    CODE
  end

  def listSharedNotebooks
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note_store.listSharedNotebooks
    CODE
  end

  def listTagsByNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

default_notebook = note_store.getDefaultNotebook

note_store.listTagsByNotebook(default_notebook.guid)
    CODE
  end

  def sendMessageToSharedNotebookMembers
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

shared_notebook = note_store.listSharedNotebooks.first

note_store.sendMessageToSharedNotebookMembers(shared_notebook.notebookGuid, "This is a test.", [])
    CODE
  end

  def setNoteApplicationDataEntry
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.setNoteApplicationDataEntry(created_note.guid, 'key', 'value')
    CODE
  end

  def setResourceApplicationDataEntry
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.setResourceApplicationDataEntry(resource_guid, 'key', 'value')
    CODE
  end

  def shareNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.shareNote(created_note.guid)
    CODE
  end

  def stopSharingNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.shareNote(created_note.guid)

note_store.stopSharingNote(created_note.guid)
    CODE
  end

  def unsetNoteApplicationDataEntry
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)

note_store.setNoteApplicationDataEntry(created_note.guid, 'key', 'value')

note_store.unsetNoteApplicationDataEntry(created_note.guid, 'key')
    CODE
  end

  def unsetResourceApplicationDataEntry
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

note_store.setResourceApplicationDataEntry(resource_guid, 'key', 'value')

note_store.unsetResourceApplicationDataEntry(resource_guid, 'key')
    CODE
  end

  def untagAll
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample #{Time.now.to_i}"]

created_note = note_store.createNote(note)
created_tag_guid = created_note.tagGuids.first

note_store.untagAll(created_tag_guid)
    CODE
  end

  def updateLinkedNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

linked_notebook = note_store.listLinkedNotebooks.first
if linked_notebook.shareName.index('[Updated] ')
  linked_notebook.shareName = linked_notebook.shareName.gsub('[Updated] ', '')
else
  linked_notebook.shareName = "[Updated] " + linked_notebook.shareName
end

note_store.updateLinkedNotebook(linked_notebook)
    CODE
  end

  def updateNote
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"
note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
created_note.title = "[Updated] " + created_note.title

note_store.updateNote(created_note)
    CODE
  end

  def updateNotebook
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

notebook = Evernote::EDAM::Type::Notebook.new
notebook.name = "Notebook #{Time.now.to_i}"

created_notebook = note_store.createNotebook(notebook)
created_notebook.name = "[Updated] " + created_notebook.name

note_store.updateNotebook(created_notebook)
    CODE
  end

  def updateResource
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new
note.title = "Note"

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hash_func = Digest::MD5.new

data = Evernote::EDAM::Type::Data.new
data.size = image.size
data.bodyHash = hash_func.digest(image)
data.body = image

resource = Evernote::EDAM::Type::Resource.new
resource.mime = "image/png"
resource.data = data
resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
resource.attributes.fileName = filename

note.resources = [resource]

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hash_func.hexdigest(image)}"/>
</en-note>
EOF
note.tagNames = ["Evernote API Sample"]

created_note = note_store.createNote(note)
resource_guid = created_note.resources.first.guid

created_resource = note_store.getResource(resource_guid, false, false, false, false)
created_resource.width = 300
created_resource.height = 300

note_store.updateResource(created_resource)
    CODE
  end

  def updateSearch
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

saved_search = Evernote::EDAM::Type::SavedSearch.new
saved_search.name = "SavedSearch #{Time.now.to_i}"
saved_search.query = "created:20070704"
saved_search.format = Evernote::EDAM::Type::QueryFormat::USER

created_saved_search = note_store.createSearch(saved_search)
created_saved_search.name = "[Updated] " + created_saved_search.name
created_saved_search.query = "created:20201231"

note_store.updateSearch(created_saved_search)
    CODE
  end

  def updateTag
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

tag = Evernote::EDAM::Type::Tag.new
tag.name = "Evernote API Sample #{Time.now.to_i}"

created_tag = note_store.createTag(tag)
created_tag.name = "[Updated] " + created_tag.name

note_store.updateTag(created_tag)
    CODE
  end

end
