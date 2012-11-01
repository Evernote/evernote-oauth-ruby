require 'open-uri'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :authtoken

  def authtoken
    session[:authtoken]
  end

end
