class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if defined? PlayAuth
    helper PlayAuth::SessionsHelper
    include PlayAuth::SessionsHelper
  end
end
