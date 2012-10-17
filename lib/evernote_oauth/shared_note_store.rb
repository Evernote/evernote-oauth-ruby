module EvernoteOAuth

  class Client
    def shared_note_store(shared_notebook, options={})
      EvernoteOAuth::SharedNoteStore.new(
        shared_notebook: shared_notebook,
        token: options[:token] || @token,
        client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
                              shared_notebook.noteStoreUrl)
      )
    end
  end

  class SharedNoteStore
    include ::EvernoteOAuth::ThriftClientDelegation
    attr_reader :token

    def initialize(options={})
      @shared_notebook = options[:shared_notebook]
      @client = options[:client]
      @token = authenticateToSharedNotebook(@shared_notebook.shareKey,
                                            options[:token]).authenticationToken
    end
  end

end
