module Evernote
  module EDAM
    module Type
      class Note
        def notebook
          @notebook ||= note_store.getNotebook(notebookGuid)
	end

	def tags
	  @tags ||= (tagGuids || []).map{|guid| note_store.getTag(guid)}
	end
      end
    end
  end
end
