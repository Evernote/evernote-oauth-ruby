module Evernote
  module EDAM
    module Type
      class Tag

        # Returns the tag that holds this tag within the tag organizational hierarchy.
        #
        # @return [Evernote::EDAM::Type::Tag]
        def parent
          @parent ||= note_store.getTag(parentGuid) if parentGuid
        end

      end
    end
  end
end
