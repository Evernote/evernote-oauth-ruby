module EvernoteOAuth

  class Client
    def note_store(options={})
      @note_store = EvernoteOAuth::NoteStore.new(
	token: options[:token] || @token,
	client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
			      options[:note_store_url] || user_store.getNoteStoreUrl)
      )
    end
  end

  class NoteStore
    include ::EvernoteOAuth::ThriftClientDelegation

    def initialize(options={})
      @token = options[:token]
      @client = options[:client]
    end
  end

end
