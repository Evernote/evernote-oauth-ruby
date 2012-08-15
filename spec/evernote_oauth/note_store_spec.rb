require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "EvernoteOAuth::NoteStore" do
  context "#initialize" do
    it "assigns instance variables and checks version" do
      note_store = EvernoteOAuth::NoteStore.new(client: 'client')
      note_store.instance_variable_get(:@client).should == 'client'
    end
  end
  context "#method_missing" do
    it "dispatches method" do
      mock_client = mock(Object)
      mock_client.should_receive(:send).with(:call_method, 'args')
      note_store = EvernoteOAuth::NoteStore.new(client: mock_client)
      note_store.call_method('args')
    end
  end
end
