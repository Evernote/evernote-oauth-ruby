module Evernote
  module EDAM
    module NoteStore
      class SyncChunk
        extend ::EvernoteOAuth::StoreAttachable
        attach_note_store :notes, :notebooks, :tags, :searches, :resources, :linkedNotebooks
      end
    end
  end
end
