module Evernote
  module EDAM
    module NoteStore
      class NoteMetadata

        # Returns the tags that are applied to this note.
        #
        # @return [Array<Evernote::EDAM::Type::Tag>]
        def tags
          @tags ||= (tagGuids || []).map{|guid| note_store.getTag(guid)}
        end

      end
    end
  end
end
