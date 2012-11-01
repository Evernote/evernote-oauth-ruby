class HomeController < ApplicationController
  def index
    @available_us_methods = UserStoreController.private_instance_methods(false).select{|m|
      !m.to_s.start_with?('_')
    }
    @unavailable_us_methods =
      Evernote::EDAM::UserStore::UserStore::Client.instance_methods(false).select{|m|
      !m.to_s.match(/send_|recv_/)
    }.sort - @available_us_methods

    @available_ns_methods = NoteStoreController.private_instance_methods(false).select{|m|
      !m.to_s.start_with?('_')
    }
    @unavailable_ns_methods =
      Evernote::EDAM::NoteStore::NoteStore::Client.instance_methods(false).select{|m|
      !m.to_s.match(/send_|recv_/)
    }.sort - @available_ns_methods
    @available_advanced_methods = AdvancedController.private_instance_methods(false).select{|m|
      !m.to_s.start_with?('_')
    }
  end

  def switch_mode
    session[:dry_run] = !session[:dry_run]
    redirect_to :root
  end

end
