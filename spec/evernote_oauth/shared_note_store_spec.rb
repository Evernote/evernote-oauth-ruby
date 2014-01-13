require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "EvernoteOAuth::SharedNoteStore" do
  include EvernoteOAuth::SharedNoteStore

  context "#initialize" do
    it "assigns instance variables" do
      sn = Struct.new(:shareKey).new('shareKey')
      auth_token = Struct.new(:authenticationToken).new('token')
      EvernoteOAuth::SharedNoteStore::Store.any_instance.should_receive(
        :authenticateToSharedNotebook).and_return(auth_token)
        note_store = EvernoteOAuth::SharedNoteStore::Store.new(client: 'client', linked_notebook: sn)
        note_store.instance_variable_get(:@client).should == 'client'
        note_store.token.should == 'token'
    end
  end
  context "#method_missing" do
    it "dispatches method" do
      mock_client = double(Object)
      mock_client.should_receive(:send).with(:call_method, 'args')
      mock_client.class.should_receive(:instance_method).with(:call_method).and_return{
        Proc.new {|a| a}
      }
      sn = Struct.new(:shareKey).new('shareKey')
      auth_token = Struct.new(:authenticationToken).new('token')
      EvernoteOAuth::SharedNoteStore::Store.any_instance.should_receive(
        :authenticateToSharedNotebook).and_return(auth_token)
        note_store = EvernoteOAuth::SharedNoteStore::Store.new(client: mock_client, linked_notebook: sn)
        note_store.call_method('args')
    end
  end
end
