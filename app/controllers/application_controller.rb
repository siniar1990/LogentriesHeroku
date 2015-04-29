require 'open-uri'


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.





  protect_from_forgery
  helper_method :current_commuter, :admin, :driver, :mobile_device?


  def new
    @commuter = Commuter.new
  end

  #Current commuter is used to keep track of which user is using an interface at given time.
  #User is signed in at all times.
  def current_commuter
    @current_commuter ||= Commuter.find_by_id(session[:commuter_id]) if session[:commuter_id]
  end

  def admin
    admin ||= Commuter.find_by_id(session[:commuter_id]) if session[:commuter_id]

    if admin.is_admin
      true
    else
      false
    end
  end

  def driver
    driver ||= Commuter.find_by_id(session[:commuter_id]) if session[:commuter_id]
    if driver.is_driver
      true
    else
      false
    end
  end



  def mobile_device?
      request.user_agent =~ /Mobile|webOS|SymbianOS|BlackBerry|iPod|iPhone|IEMobile|Android/
  end





end

