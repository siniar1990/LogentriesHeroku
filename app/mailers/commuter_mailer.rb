class CommuterMailer < ActionMailer::Base
  default from: 'info@imeallsoftware.com'

  def welcome_email(commuter)
    @commuter = commuter
    @url = 'http://tinyurl.com/WexfordBusSeatReservation'


    mail(:to => commuter.email, :subject => 'Wexford Bus Seat Reservation')
  end

  def custom_email(commuter)

      @commuter = commuter
      @url = 'http://tinyurl.com/WexfordBusSeatReservation'

      mail(:to => commuter.email, :subject => 'Your login details')
  end




  def booking_confirmation_email(commuter, origin, destination, time, date)
    @commuter= commuter
    @origin = origin
    @destination = destination
    @time = time
    @date = date

    @url = 'http://localhost:3000/bus_connections'
    @site_name = "localhost"
    mail(:to => commuter.email, :subject => 'Booking confirmation for ' + Time.parse(@date).strftime("%d of %B, %Y"))
  end

  def warning_email(commuter)
    @commuter = commuter
    mail(:to => commuter.email, :subject => 'You missed your bus')
  end

  def suspension_email(commuter)
    @commuter = commuter
    mail(:to => commuter.email, :subject => 'Your account was suspended')
  end



end

