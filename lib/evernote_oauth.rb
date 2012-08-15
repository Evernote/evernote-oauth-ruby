require 'rubygems'
require 'thrift_client'
require 'oauth'
require 'yaml'

vendor_path = File.expand_path(File.dirname(__FILE__) + "/../vendor")
$LOAD_PATH.unshift "#{vendor_path}/evernote/edam"

require "#{vendor_path}/evernote"

require 'evernote_oauth/client'
require 'evernote_oauth/user_store'
require 'evernote_oauth/note_store'
require 'evernote_oauth/version'

# Path Thrift 0.8.0 Gem for Ruby 1.9.3 compatibility
# See: http://discussion.evernote.com/topic/15321-evernote-ruby-thrift-client-error/
#
if Gem::Version.new(RUBY_VERSION.dup) == Gem::Version.new('1.9.3') &&
  Gem.loaded_specs['thrift'].version == Gem::Version.new('0.8.0')
  module Thrift
    class HTTPClientTransport < BaseTransport

      def flush
	http = Net::HTTP.new @url.host, @url.port
	http.use_ssl = @url.scheme == "https"
	resp, data = http.post(@url.request_uri, @outbuf, @headers)
	# Was: @inbuf = StringIO.new data
	@inbuf = StringIO.new resp.body
	@outbuf = ""
      end
    end
  end
end
