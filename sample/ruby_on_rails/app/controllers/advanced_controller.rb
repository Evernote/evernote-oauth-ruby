class AdvancedController < EvernoteController

  def call
    begin
      send(params[:method])
    rescue NoMethodError => e
      redirect_to root_path and return
    end

    @result = run_code? ? eval(@code) : "N/A" rescue $!

    @docs, @doc_urls = [], []
    (@class_and_methods || []).each do |cm|
      @docs << doc(cm[:clazz], cm[:method])
      @doc_urls << @doc_url
    end

    render 'advanced/api_result'
  end

  private
  def count_notes_by_notebook_name
    @class_and_methods = [
      {clazz: 'NoteStore', method: 'listNotebooks'},
      {clazz: 'NoteStore', method: 'findNoteCounts'}
    ]
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

notebooks = note_store.listNotebooks
notebook_names_by_guid = Hash[notebooks.map{|n| [n.guid, n.name]}]

note_counts = note_store.findNoteCounts(Evernote::EDAM::NoteStore::NoteFilter.new, false)

Hash[note_counts.notebookCounts.map{|guid, count|
  [notebook_names_by_guid[guid], count]
}]
    CODE
  end

  def create_note_with_image
    @class_and_methods = [
      {clazz: 'NoteStore', method: 'createNote'}
    ]
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
note_store = client.note_store

note = Evernote::EDAM::Type::Note.new(
  title: 'Note',
  tagNames: ['Evernote API Sample']
)

filename = "enlogo.png"
image = File.open(File.join(Rails.root, 'public', filename), "rb") { |io| io.read }
hexdigest = note.add_resource(filename, image, 'image/png')

note.content = <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note>Content<br/>
  <en-media type="image/png" hash="\#{hexdigest}"/>
</en-note>
EOF

note_store.createNote(note)
    CODE
  end

end
