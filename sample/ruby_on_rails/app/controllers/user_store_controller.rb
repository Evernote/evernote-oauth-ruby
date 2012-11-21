class UserStoreController < EvernoteController

  private
  def authenticate; end

  def checkVersion
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
user_store.checkVersion('Evernote EDAMTest (Ruby)', Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR, Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
    CODE
  end

  def getBootstrapInfo
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
user_store.getBootstrapInfo('en_US')
    CODE
  end

  def getNoteStoreUrl
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
user_store.getNoteStoreUrl
    CODE
  end

  def getPremiumInfo
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
user_store.getPremiumInfo
    CODE
  end

  def getPublicUserInfo
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
user_store.getPublicUserInfo('evernote')
    CODE
  end

  def getUser
    @code = <<-CODE
client = EvernoteOAuth::Client.new(token: authtoken)
user_store = client.user_store
user_store.getUser
    CODE
  end

  def refreshAuthentication; end

end
