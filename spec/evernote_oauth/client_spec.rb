require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "EvernoteOAuth::Client" do
  before :each do
    @client = EvernoteOAuth::Client.new(
      consumer_key: 'consumer_key',
      consumer_secret: 'consumer_secret',
      sandbox: false,
      token: 'token',
      secret: 'secret'
    )
  end
  context "#initialize" do
    it "assigns instance variables" do
      @client.instance_variable_get(:@consumer_key).should == 'consumer_key'
      @client.instance_variable_get(:@consumer_secret).should == 'consumer_secret'
      @client.instance_variable_get(:@sandbox).should == false
      @client.instance_variable_get(:@token).should == 'token'
      @client.instance_variable_get(:@secret).should == 'secret'
    end
  end
  context "#authorize" do
    it "assigns returns access token" do
      mock_access_token = double(OAuth::AccessToken)
      mock_access_token.should_receive(:token).and_return('token')
      mock_access_token.should_receive(:secret).and_return('secret')
      mock_request_token = double(OAuth::RequestToken)
      mock_request_token.should_receive(:get_access_token).and_return(mock_access_token)
      OAuth::RequestToken.stub(:new){mock_request_token}

      @client.authorize('token', 'secret').should == mock_access_token
    end
  end
  context "#request_token" do
    it "calls OAuth::Consumer#get_request_token" do
      mock_request_token = double(OAuth::RequestToken)
      mock_consumer = double(OAuth::Consumer)
      mock_consumer.should_receive(:options).and_return({})
      mock_consumer.should_receive(:get_request_token).with({}).and_return(mock_request_token)
      @client.stub(:consumer){mock_consumer}
      @client.request_token.should == mock_request_token
    end
  end
end
