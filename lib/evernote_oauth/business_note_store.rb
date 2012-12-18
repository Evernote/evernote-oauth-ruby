module EvernoteOAuth

  class Client
    def business_note_store(options={})
      auth = user_store.authenticateToBusiness(options[:token] || @token)
      EvernoteOAuth::BusinessNoteStore.new(
        token: auth.authenticationToken,
        client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
                              auth.noteStoreUrl)
      )
    end
  end

  class BusinessNoteStore
    include ::EvernoteOAuth::ThriftClientDelegation
    attr_reader :token

    def initialize(options={})
      @token = options[:token]
      @client = options[:client]
    end
  end

end
