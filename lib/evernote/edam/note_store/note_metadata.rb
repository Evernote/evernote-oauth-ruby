module Evernote
  module EDAM
    module NoteStore
      class NoteMetadata
	def tags
	  @tags ||= (tagGuids || []).map{|guid| note_store.getTag(guid)}
	end
      end
    end
  end
end
