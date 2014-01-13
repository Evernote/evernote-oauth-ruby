require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "EvernoteOAuth::UserStore" do
  include EvernoteOAuth::UserStore

  context "#initialize" do
    it "assigns instance variables and checks version" do
      EvernoteOAuth::UserStore::Store.any_instance.stub(:version_valid?){true}
      user_store = EvernoteOAuth::UserStore::Store.new(client: 'client')
      user_store.instance_variable_get(:@client).should == 'client'
    end
    it "raises error when version is not valid" do
      EvernoteOAuth::UserStore::Store.any_instance.stub(:version_valid?){false}
      lambda{EvernoteOAuth::UserStore::Store.new(client: 'client')}.should raise_error
    end
  end
  context "#method_missing" do
    it "dispatches method" do
      mock_client = double(Object)
      mock_client.should_receive(:send).with(:call_method, 'args')
      mock_client.class.should_receive(:instance_method).with(:call_method).and_return{
        Proc.new {|a| a}
      }
      EvernoteOAuth::UserStore::Store.any_instance.stub(:version_valid?){true}
      user_store = EvernoteOAuth::UserStore::Store.new(client: mock_client)
      user_store.call_method('args')
    end
  end
end
