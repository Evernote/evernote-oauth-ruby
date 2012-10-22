module Evernote
  module EDAM
    module Type
      class SharedNotebook
        def notebook
          @notebook ||= note_store.getNotebook(notebookGuid)
	end
      end
    end
  end
end
