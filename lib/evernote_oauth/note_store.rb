module EvernoteOAuth

  module NoteStore
    include ::EvernoteOAuth::UserStore

    # Returns note_store
    #
    # @return [EvernoteOAuth::NoteStore::Store]
    def note_store(options={})
      @note_store = EvernoteOAuth::NoteStore::Store.new(
        token: options[:token] || @token,
        client: thrift_client(::Evernote::EDAM::NoteStore::NoteStore::Client,
                              options[:note_store_url] || user_store.getNoteStoreUrl)
      )
    end

    class Store
      include ::EvernoteOAuth::ThriftClientDelegation

      def initialize(options={})
        @token = options[:token]
        @client = options[:client]
      end

    end

  end

end
