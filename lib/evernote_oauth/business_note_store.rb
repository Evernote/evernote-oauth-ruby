module EvernoteOAuth

  module BusinessNoteStore
    include UserStore

    # Returns note_store for a business account
    #
    # @return [EvernoteOAuth::BusinessNoteStore::Store]
    def business_note_store(options={})
      auth = user_store.authenticateToBusiness(options[:token] || @token)
      EvernoteOAuth::BusinessNoteStore::Store.new(
        token: auth.authenticationToken,
        client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
                              auth.noteStoreUrl),
        user: auth.user
      )
    end

    class Store
      include ::EvernoteOAuth::ThriftClientDelegation
      attr_reader :token, :user

      def initialize(options={})
        @token = options[:token]
        @client = options[:client]
        @user = options[:user]
      end
    end

  end

end
