module Evernote
  module EDAM
    module Type
      class Resource
	@note_by_options = {}

        def note(options)
	  options = {
	    with_content: false,
	    with_resources_data: false,
	    with_resources_recognition: false,
	    with_resources_alternate_data: false
	  }.merge(options)

	  @note_by_opions[options] ||
	    (@note_by_options[options] = note_store.getNote(
	      noteGuid,
	      options[:with_content],
	      options[:with_resources_data],
	      options[:with_resources_recognition],
	      options[:with_resources_alternate_data])
	    )
	end
      end
    end
  end
end
