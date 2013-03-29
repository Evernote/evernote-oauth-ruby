module Evernote
  module EDAM
    module Type
      class Notebook

        # Determines if the user can create notes in this notebook.
        #
        # @return [Boolean]
        def writable?
          !self.restrictions.noCreateNotes
        end

      end
    end
  end
end
