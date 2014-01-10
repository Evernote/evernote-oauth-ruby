# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'evernote_oauth/version'

Gem::Specification.new do |s|
  s.name = %q{evernote_oauth}
  s.version = EvernoteOAuth::VERSION

  s.authors = ["Evernote"]
  s.date = Time.now.strftime('%Y-%m-%d')
  s.licenses = ['BSD 2-Clause']
  s.description = %q{evernote_oauth is a Ruby client for the Evernote API using OAuth and Thrift.}
  s.email = %q{api@evernote.com}
  s.files = ["LICENSE", "README.md", "evernote_oauth.gemspec"] + Dir.glob('{lib,spec}/**/*')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/evernote/evernote-oauth-ruby}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{evernote_oauth}
  s.rubygems_version = EvernoteOAuth::VERSION
  s.summary = %q{Ruby client for the Evernote API using OAuth and Thrift.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    s.add_dependency 'oauth', '>= 0.4.1'
    s.add_dependency 'evernote-thrift'
    s.add_development_dependency 'rspec'
    s.add_development_dependency 'yard'
    s.add_development_dependency 'redcarpet'
  end
end
