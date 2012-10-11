module EvernoteOAuth

  class Client
    def note_store(options={})
      @note_store = EvernoteOAuth::NoteStore.new(
	client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
			      options[:note_store_url] || user_store.getNoteStoreUrl(@token))
      )
    end
  end

  class NoteStore
    def initialize(options={})
      @client = options[:client]
    end

    def method_missing(name, *args, &block)
      @client.send(name, *args, &block)
    end
  end

end
