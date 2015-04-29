class AuthenticationController < ApplicationController

  def sign_in
    @commuter = Commuter.new
  end

  # ========= Signing In ==========

  def login
    commuter_name = params[:commuter][:username]
    commuter_password = params[:commuter][:password]

    # Find commuter
    commuter = Commuter.authenticate_by_username(commuter_name, commuter_password)


    # If commuter is found
    if commuter

      # First check if commuter is suspended
      # True = suspended
      # False = active
      if commuter && commuter.suspended != true
        session[:commuter_id] = commuter.id
        flash[:notice] = 'Welcome.'
        redirect_to '/home'



      # If commuter is suspended bring him back to sing in page and show the notice
      elsif commuter.suspended
        flash[:error] = "Sorry, your account is suspeded"
        redirect_to '/sign_in'


      # When all of the above methods fail, display error message
      else
        flash[:error] = 'Wrong username or password'
        redirect_to '/sign_in'

      end

    # If commuter isn't found display a notice
    # More functionality needs to be added here
    else
      flash[:error] = "Wrong username or password"

      redirect_to '/sign_in'
    end
  end

  # ========= Signing Out ==========

  def signed_out
    session[:commuter_id] = nil
    flash[:notice] = "You have been signed out"
    redirect_to '/sign_in'

  end



  def my_reservations


    @reservations = Reservation.where(:user => current_commuter.username)
    @activeReservations = Array.new
    today = Date.new(Time.now.year, Time.now.month, Time.now.day)


    p "TODAY"
    p today



    # This needs to be changed so no reservations an hour and less away from the departure time are available to view

    @reservations.each do |reservation|

    if Date.parse(reservation["date"]) >= today
      @activeReservations.append(reservation)
    end

    end
    @reservations.sort_by! { |x| x[:date] }.reverse!
  end



end