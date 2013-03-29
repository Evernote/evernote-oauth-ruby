module EvernoteOAuth
  class Client
    include ::EvernoteOAuth::UserStore
    include ::EvernoteOAuth::NoteStore
    include ::EvernoteOAuth::SharedNoteStore
    include ::EvernoteOAuth::BusinessNoteStore
    include ::EvernoteOAuth::BusinessUtils

    def initialize(options={})
      config_file = "config/evernote.yml"
      if File.exist?(config_file)
        require 'erb'
        if defined?(Rails)
          config = YAML.load(ERB.new(File.read(config_file)).result)[Rails.env]
        else
          config = YAML.load(ERB.new(File.read(config_file)).result)
        end
        @consumer_key = config['consumer_key']
        @consumer_secret = config['consumer_secret']
        @sandbox = config['sandbox'] ? true : false
      end

      @consumer_key = options[:consumer_key] || @consumer_key
      @consumer_secret = options[:consumer_secret] || @consumer_secret
      @sandbox = true if @sandbox == nil
      @sandbox = (options[:sandbox] == nil ? @sandbox : options[:sandbox])
      @service_host = options[:service_host] || (@sandbox ? 'sandbox.evernote.com' : 'www.evernote.com')
      @additional_headers = options[:additional_headers]
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
      consumer.options[:authorize_path] = '/OAuth.action'
      consumer.get_request_token(options)
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
      url = "https://#{@service_host}"
      url += "/#{path}" if path
      url
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer, @token, @secret)
    end

    def thrift_client(client_class, url)
      if m = /:A=([^:]+):/.match(@token)
        key_id = m[1]
      else
        key_id = @consumer_key || 'nil'
      end

      transport = Thrift::HTTPClientTransport.new(url)
      transport.add_headers(
        'User-Agent' => "#{key_id} / #{::EvernoteOAuth::VERSION}; Ruby / #{RUBY_VERSION};"
      )
      transport.add_headers(@additional_headers) if @additional_headers
      protocol = Thrift::BinaryProtocol.new(transport)
      client_class.new(protocol)
    end

  end
end

