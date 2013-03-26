module Evernote
  module EDAM
    module Type
      class SharedNotebook

        # Returns the associated notebook shared
        #
        # @reutrn [Evernote::EDAM::Type::Notebook]
        def notebook
          @notebook ||= note_store.getNotebook(notebookGuid)
        end

      end
    end
  end
end
