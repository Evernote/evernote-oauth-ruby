class LoginController < ApplicationController
  rescue_from OAuth::Unauthorized, :with => Proc.new{redirect_to root_path}

  def callback
    session[:authtoken] = request.env['omniauth.auth']['credentials']['token']
    session[:dry_run] = true
    redirect_to root_path
  end

  def oauth_failure
    redirect_to root_path
  end

  def logout
    session.clear
    redirect_to root_path
  end

end
