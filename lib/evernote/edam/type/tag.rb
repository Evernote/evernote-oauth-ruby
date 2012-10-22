module Evernote
  module EDAM
    module Type
      class Tag
        def parent
          @parent ||= note_store.getTag(parentGuid) if parentGuid
	end
      end
    end
  end
end
