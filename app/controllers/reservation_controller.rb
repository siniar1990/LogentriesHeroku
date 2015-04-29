class ReservationController < ApplicationController

  def new
    @reservation = Reservation.new
  end

  def create
    reservation = Reservation.new(params[:reservation])

    if reservation.valid?
      reservation.save

      flash[:notice] = "New reservation created"
      redirect_to :root

    else
      flash[:error] = "Reservation not created"
      render :action => 'create_reservation'
    end
  end

  #========== SHOW DETAILS OF RESERVATION =========
  def find
      @reservations = Reservation.where(:user => params[:reservation][:user])
      @list = Array.new
      @found_reservation = false
      @commuter = Commuter.find_by_username(params[:reservation][:user])


      #If user exists do reservation check
      if @commuter

        #If user reserved something in the past display it
        if @reservations.length != 0
          for i in 0..@reservations.length-1
            @res = @reservations[i]
            @list.push(@res)
          end

          @found_reservation = true
          render :action => 'find_reservation'

        #If user had no previous reservations, send error message
        else
          flash[:error] = "No reservations for this user"
          render :action => 'find_reservation'
        end
      else
        #If user doesn't exist send error message
        flash[:error] = "User doesn't exist"
        render :action => 'find_reservation'
      end

  end




end