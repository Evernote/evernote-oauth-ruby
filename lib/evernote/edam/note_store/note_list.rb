module Evernote
  module EDAM
    module NoteStore
      class NoteList
        extend ::EvernoteOAuth::StoreAttachable
        attach_note_store :notes
      end
    end
  end
end
