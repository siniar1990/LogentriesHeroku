require "json"

class OperatorController < ApplicationController



  def new
    @commuter = Commuter.new
  end

  #========== REGISTER NEW COMMUTER =========

  def register
    commuter = Commuter.new(params[:commuter])

    # TODO: I need to look into validations and safety statements again but it works fine for now
    # TODO: For example we're still able to create user of which ID isn't exactly 12 characters - invalid

    if commuter.valid?
       commuter.save

      CommuterMailer.welcome_email(commuter).deliver

      flash[:notice] = "New user created"
      redirect_to '/home'

    else
      flash[:error] = "User not created"
      render :action => "create_commuter"
    end
  end


  #========== DELETE EXISTING COMMUTER =========

  def delete
      commuter_name = params[:commuter][:username]

      commuter = Commuter.find_by_username(commuter_name)


      # If commuter exists delete it, but keep all of his reservations in the database for lookback purposes
      if commuter

        if commuter.is_admin
          flash[:error] = "Cannot delete admin account, this has to be done manually"
          render :action => "delete_commuter"
        else

        commuter.delete
        flash[:notice] = "Commuter " + commuter_name + " has been deleted"
        render :action => "delete_commuter"

        end
      else
        flash[:error] = "User doesn't exist "
        render :action => "delete_commuter"
      end


  end

  #========== SHOW DETAILS OF USER =========


  def show

    # Make this global to be accessed by view
    @commuter = Commuter.find_by_username(params[:commuter][:username])

    # If commuter exists
    if @commuter

      p @commuter.username
      p @commuter.password_hash

    flash[:notice] = "User " + @commuter.username + " found in database"
    render :action => "commuter_details"

    # If commuter doesn't exist
    else
      flash[:error] = "User doesn't exist"
      render :action => 'show_commuter'
    end
  end

  #========== SUSPEND USER =========

  def suspend
    @commuter = Commuter.find_by_username(params[:commuter][:username])

    # If commuter exists
    if @commuter
    # If commuter exists and isn't suspended
    if @commuter.suspended.equal?(false)

      # Change value in database to : SUSPENDED
      @commuter.suspended = true
      @commuter.save

      flash[:notice] = "User " + @commuter.username + " suspended successfully"
      redirect_to :root

    # If user is already supended flash a notice
    else
      flash[:notice] = "User " + @commuter.username + " is already suspended, would you like to activate ?"
      render :action => 'activate_commuter'
    end

      # If user doesn't exist flash a notice and bring us back to commuter suspension function
      else
        flash[:error] = "User doesn't exist"
        render :action => 'suspend_commuter'
    end
  end

  #========== ACTIVATE USER =========

  def activate
    @commuter = Commuter.find_by_username(params[:commuter][:username])

    # If commuter exists
    if @commuter
      # If commuter exists and is suspended
      if @commuter.suspended.equal?(true)

        # If commuter missed 3 buses which makes him suspended reset number of missed busses
        if @commuter.missed >=3
          @commuter.missed = 0

        # Activate commuter and save it to database
        end
        @commuter.suspended = false
        @commuter.save

        flash[:notice] = "User " + @commuter.username + " active again"
        redirect_to :root

      # If commuter is already active
      else
        flash[:notice] = "User " + @commuter.username + " is already active"
        render :action => 'activate_commuter'
      end
    # If commuter doesn't exist
    else
      flash[:error] = "User doesn't exist"
      render :action => 'activate_commuter'

    end

  end

  #Im giving it threshold 3
  def warn
    commuter_name = params[:commuter][:username]

    commuter = Commuter.find_by_username(commuter_name)

    # If commuter exists and isn't suspended
    if commuter
      if commuter.suspended == false

        # Increment suspended count
        missed_buses = commuter.missed
        missed_buses += 1

        commuter.missed = missed_buses
        commuter.save

        # Send warning email
        CommuterMailer.warning_email(commuter).deliver


        if commuter.missed > 2
          commuter.suspended = true
          commuter.save

          CommuterMailer.suspension_email(commuter).deliver
          flash[:notice] = 'Commuter reached threshold and got suspended'
        end

        render :action => 'warn_commuter'
      else
        flash[:error] = "User suspended"

      end
    else
      flash[:error] = "Commuter not found"
      render :action => 'warn_commuter'

    end
  end

  def past
    @pastReservations = Array.new

    # All reservations
    Reservation.all.each do  |reservation|
      reservation["date"] = Date.parse(reservation["date"])

      if reservation["date"] < Date.new(Time.now.year, Time.now.month, Time.now.day)
        @pastReservations.append(reservation)
      end

      @pastReservations.sort_by! { |x| x[:date] }
      end

  end

  def today
    @todayReservations = Array.new

    # All reservations
    Reservation.all.each do  |reservation|
      reservation["date"] = Date.parse(reservation["date"])

      if reservation["date"] == Date.new(Time.now.year, Time.now.month, Time.now.day)
        @todayReservations.append(reservation)
      end

      @todayReservations.sort_by! { |x| x[:date] }
    end

  end

  def future
    @futureReservations = Array.new



    # All reservations
    Reservation.all.each do  |reservation|

      reservation["date"] = Date.parse(reservation["date"])

      if reservation["date"] > Date.new(Time.now.year, Time.now.month, Time.now.day)


        @futureReservations.append(reservation)
      end

      @futureReservations.sort_by! { |x| x[:date] }
    end

  end

  def display_reservations
      # EMPTY METHOD
  end



  def reservations

    today = Date.new(Time.now.year, Time.now.month, Time.now.day).strftime("%Y/%m/%d")


    # Select only reservations for today Date.new(Time.now.year, Time.now.month, Time.now.day).strftime("%Y/%m/%d")
    @reservations_for_540 = Reservation.all.where(:date => today , :route => '540' )
    @reservations_for_545 = Reservation.all.where(:date => today, :route => '545' )
    @reservations_for_550 = Reservation.all.where(:date => today, :route => '550' )
    @reservations_for_555 = Reservation.all.where(:date => today, :route => '555' )

    p @reservations_for_540
    p @reservations_for_545
    p @reservations_for_550
    p @reservations_for_555

  end

  def all_users

    @allusers = Commuter.all


  end



end