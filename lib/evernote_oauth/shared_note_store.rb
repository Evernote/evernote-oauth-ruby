module EvernoteOAuth

  module SharedNoteStore

    # Returns note_store for a shared notebook
    #
    # @param linked_notebook [Evernote::EDAM::Type::LinkedNotebook]
    # @return [EvernoteOAuth::SharedNoteStore::Store]
    def shared_note_store(linked_notebook, options={})
      EvernoteOAuth::SharedNoteStore::Store.new(
        linked_notebook: linked_notebook,
        token: options[:token] || @token,
        client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
                              linked_notebook.noteStoreUrl)
      )
    end

    class Store
      include ::EvernoteOAuth::ThriftClientDelegation
      attr_reader :token

      def initialize(options={})
        @linked_notebook = options[:linked_notebook]
        @client = options[:client]
        @token = authenticateToSharedNotebook(@linked_notebook.shareKey,
                                              options[:token]).authenticationToken
      end
    end

  end

end
