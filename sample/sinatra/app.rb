##
# en_webhook.rb
# Copyright 2013 Evernote Corporation. All rights reserved.
#
# This sample web application demonstrates the process of using Webhook.
# More information can be found in http://dev.evernote.com/documentation/cloud/chapters/polling_notification.php#webhooks.
#
# Note that we're not attempting to demonstrate Ruby/Sinatra best practices or
# build a scalable multi-user web application, we're simply giving you an idea
# of how to use Webhook.
#
# Note that you can't use webhook on your localhost.
# You have to deploy your applicatin on a public server and request a webhook.
# http://dev.evernote.com/support/
#
# Requires the Sinatra framework, ActiveRecord and the OAuth RubyGem. You can install these
# components as follows:
#
#   gem install evernote_oauth
#   gem install sinatra
#   gem install active_record
#
# To run this application:
#
#   ruby -rubygems en_webhook.rb
#
# Sinatra will start on port 4567. You can view the sample application by visiting
# http://localhost:4567 in a browser.
##

class User < ActiveRecord::Base
  validates :user_id, :username, :token, :active, presence: true
  after_initialize :set_default
  def set_default
    self.active ||= true
  end
end

class Note < ActiveRecord::Base
  validates :guid, :user_id, :title, :content, presence: true
end

class EnWebhook < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions

  ##
  # Index page
  ##
  get '/' do
    if session[:user_id]
      redirect '/notes'
    else
      slim :authorize
    end
  end

  ##
  # Reset the session
  ##
  get '/reset' do
    session.clear
    slim :authorize
  end

  ##
  # Get temporary credentials and redirect the user to Evernote for authoriation
  ##
  get '/authorize' do
    callback_url = request.url.chomp("authorize").concat("callback")

    begin
      client = EvernoteOAuth::Client.new
      session[:request_token] = client.request_token(:oauth_callback => callback_url)
      redirect session[:request_token].authorize_url
    rescue => e
      @error = "Error obtaining temporary credentials: #{e.message}"
      slim :error
    end
  end

  ##
  # Receive callback from the Evernote authorization page and exchange the
  # temporary credentials for an token credentials.
  ##
  get '/callback' do
    if params['oauth_verifier']
      oauth_verifier = params['oauth_verifier']

      begin
        access_token = session[:request_token].get_access_token(:oauth_verifier => oauth_verifier).token

        # Create User record with username and token
        user_store = EvernoteOAuth::Client.new(token: access_token).user_store
        evernote_user = user_store.getUser

        @user = User.find_or_initialize_by_user_id(user_id: evernote_user.id)
        @user.username = evernote_user.username
        @user.token = access_token
        @user.save!

        session[:user_id] = @user.user_id
        redirect '/notes'
      rescue => e
        @error = e.message
        slim :error
      end
    else
      @error = "Content owner did not authorize the temporary credentials"
      slim :error
    end
  end

  get '/notes' do
    @user = User.find_by_user_id(session[:user_id])
    redirect '/reset' unless @user

    @notes = Note.where(user_id: @user.user_id)

    note_store = EvernoteOAuth::Client.new(token: @user.token).note_store
    @evernote_notes = note_store.findNotesMetadata(
      ::Evernote::EDAM::NoteStore::NoteFilter.new, 0, 10,
      ::Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new).notes
    slim :notes
  end

  ##
  # Handle webhook notification from the Evernote.
  #
  # In this sample, it simply saves and updates title and content of a note according to the parameter.
  #
  # It is important that when your web service receives a polling notification from Evernote,
  # it returns HTTP status code 200 (the standard response for successful HTTP requests).
  #
  # Specifically, your service should not return a failure code (e.g.: HTTP 500) when called by Evernote.
  # Even when the notification may not be relevant to your application, you should return 200.
  # A status other than 200 indicates to us that the message was not delivered successfully,
  # which could cause your integration with Evernote to malfunction.
  #
  # http://dev.evernote.com/documentation/cloud/chapters/polling_notification.php
  ##
  get '/webhook' do
    # Evernote webhook should include userId, guid and reason in its parameter
    halt 400 unless params.include?('userId') && params.include?('guid') && params.include?('reason')
    # Reason should be either craete or update
    halt 400 unless ['create', 'update'].include?(params[:reason])

    begin
      evernote_user_id = params[:userId]
      note_guid = params[:guid]

      @user = User.find_by_user_id(evernote_user_id)
      return if @user.nil? || !@user.active?

      note_store = EvernoteOAuth::Client.new(token: @user.token).note_store
      evernote_note = note_store.getNote(note_guid, true, false, false, false)
      @note = Note.find_or_initialize_by_user_id_and_guid(@user.user_id, note_guid)
      @note.title = evernote_note.title
      @note.content = evernote_note.content
      @note.save!
    rescue
      puts $!
      @user.update_attribute(:active, false)
      redirect '/'
      return
    end

    # Just returning 200 is fine.  This is only for showing webhook result on the browser.
    @notes = Note.where(user_id: @user.user_id)
    note_store = EvernoteOAuth::Client.new(token: @user.token).note_store
    @evernote_notes = note_store.findNotesMetadata(
      ::Evernote::EDAM::NoteStore::NoteFilter.new, 0, 10,
      ::Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new).notes
      slim :notes
  end

end
