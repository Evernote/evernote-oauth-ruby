module EvernoteOAuth

  class Client
    def user_store(options={})
      @user_store = EvernoteOAuth::UserStore.new(
	client: thrift_client(::Evernote::EDAM::UserStore::UserStore::Client,
			      endpoint('edam/user'), options)
      )
    end
  end

  class UserStore
    def initialize(options={})
      @client = options[:client]
      raise 'API version is not up to date' unless version_valid?
    end

    def method_missing(name, *args, &block)
      @client.send(name, *args, &block)
    end

    def version_valid?
      checkVersion("EDAMTest",
                   ::Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                   ::Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
    end
  end

end
