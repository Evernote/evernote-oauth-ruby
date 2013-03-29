module EvernoteOAuth

  module UserStore

    # Returns user_store
    #
    # @return [EvernoteOAuth::UserStore::Store]
    def user_store
      @user_store = EvernoteOAuth::UserStore::Store.new(
        token: @token,
        client: thrift_client(::Evernote::EDAM::UserStore::UserStore::Client,
                              endpoint('edam/user'))
      )
    end

    class Store
      include ::EvernoteOAuth::ThriftClientDelegation

      def initialize(options={})
        @token = options[:token]
        @client = options[:client]
        raise 'API version is not up to date' unless version_valid?
      end

      def version_valid?
        checkVersion("EDAMTest",
                     ::Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                     ::Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
      end
    end

  end

end
