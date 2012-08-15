# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'evernote_oauth/version'

Gem::Specification.new do |s|
  s.name = %q{evernote_oauth}
  s.version = EvernoteOAuth::VERSION

  s.authors = ["Kentaro Suzuki"]
  s.date = %q{2012-08-14}
  s.description = %q{evernote_oauth is a Ruby client for the Evernote API using OAuth and Thrift.}
  s.email = %q{ksuzuki@gmail.com}
  s.files = ["LICENSE", "README.md", "evernote_oauth.gemspec"] + Dir.glob('{lib,spec,vendor}/**/*')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/rekotan/evernote_oauth}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{evernote_oauth}
  s.rubygems_version = %q{0.0.1}
  s.summary = %q{evernote_oauth is a Ruby client for the Evernote API using OAuth and Thrift.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    s.add_dependency 'oauth', '>= 0.4.1'
    s.add_dependency 'thrift_client', '>= 0.8.1'
    s.add_development_dependency 'rspec'
  end
end
