module EvernoteOAuth
  class Client

    def initialize(options={})
      config_file = "config/evernote.yml"
      if File.exist?(config_file)
	config = YAML.load(ERB.new(File.read(config_file)).result)[Rails.env]
	@consumer_key = config['consumer_key']
	@consumer_secret = config['consumer_secret']
	@sandbox = config['sandbox'] ? true : false
      end

      @consumer_key ||= options[:consumer_key]
      @consumer_secret ||= options[:consumer_secret]
      @sandbox = options[:sandbox] if options[:sandbox]
      @sandbox = true unless @sandbox
      @token = options[:token]
      @secret = options[:secret]
    end

    def authorize(token, secret, options={})
      request_token = OAuth::RequestToken.new(consumer, token, secret)
      @access_token = request_token.get_access_token(options)
      @token = @access_token.token
      @secret = @access_token.secret
      @access_token
    end

    def request_token(options={})
      consumer.get_request_token(options)
    end

    def authentication_request_token(options={})
      consumer.options[:authorize_path] = '/OAuth.action'
      request_token(options)
    end

    private
      def consumer
        @consumer ||= OAuth::Consumer.new(
          @consumer_key,
          @consumer_secret,
          {site: endpoint,
            request_token_path: "/oauth",
            access_token_path: "/oauth"}
        )
      end

      def endpoint(path=nil)
        url = @sandbox ? "https://sandbox.evernote.com" : "https://www.evernote.com"
	url += "/#{path}" if path
	url
      end

      def access_token
	@access_token ||= OAuth::AccessToken.new(consumer, @token, @secret)
      end

      def thrift_client(client_class, url, options={})
	@thrift_client = ThriftClient.new(client_class, url, options.merge(
          transport: Thrift::HTTPClientTransport))
      end

  end
end

