require 'evernote_oauth'
require 'rspec'

Dir.glob(File.join(File.join(File.dirname(__FILE__), "..", "lib"), "**")).each do |file|
  require file
end
