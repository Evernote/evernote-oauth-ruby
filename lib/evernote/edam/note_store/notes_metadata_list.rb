module Evernote
  module EDAM
    module NoteStore
      class NotesMetadataList
        extend NoteStoreAttachable
        attach_note_store :notes
      end
    end
  end
end
