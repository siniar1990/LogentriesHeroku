#TODO: I need to pass not just times, but route as well.
#TODO: I can do it using 2d array

require 'rubygems'
require 'json'
require 'pp'
require 'open-uri'
require 'time'


class HomeController < ApplicationController

  @past_date = false

  def isSaturday(date)
    if date.saturday?
      true
    else
      false
    end
  end

  def isSunday(date)
    if date.sunday?

      true
    else
      false
    end
  end

  def isWeekday(date)
    if date.monday? || date.tuesday? || date.wednesday? || date.thursday? || date.friday?
      true
    else
      false
    end
  end

  def isBankHoliday(date)


    json = ActiveSupport::JSON.decode(open('http://www.textmemybus.com/bankholidays/bankholidays.json').read)

    bankHol = false

    for i in 0..json.length-1
      #This is necessary to bring date to the same format as in JSON file
      json_date = json[i]["year"].to_s + "-" + json[i]["month"].to_s + "-" + json[i]["day"].to_s
      formatted_date = Date.parse(json_date)

      if formatted_date == date
        bankHol = true
      else
        bankHol = false
      end
    end

    bankHol
  end



  # This method takes date and json file
  # We're returning an array of times for this specific day instead of just true/false

  def BusesTravelThisDay(date, json)
    p "BusesTravelThisDay Called"


    parsed_date = Date.new(date.year, date.month, date.day)
    current_date = Date.new(Time.now.year, Time.now.month, Time.now.day)




    for i in 0..json["times"].length-1
      timer = Time.parse(json["times"][i]["time"])

      # Temporary array to store Time and Route which is going to be pushed into travel_times_array
      @time_and_route = Array.new

      p "Travel times array"
      p @travel_times

      #***********************************************************************************
      #************************** IF DATE IS IN THE FUTURE *******************************
      #***********************************************************************************

      if parsed_date > current_date
          #Bus travels everyday

          if json["times"][i]["details"] == 'Everyday'

            @time_and_route.append(json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)


          end

          #Bus travels everyday, but doesn't server Dublin City stops
          if json["times"][i]["details"] == 'Everyday, No Dublin city stops served'

            @time_and_route.append('*'+json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)

          end

          #Bus isn't travelling on sundays or bank holidays
          if json["times"][i]["details"] == 'Not on Sundays or Bank Holidays' && !(isSunday(date) || isBankHoliday(date))

            @time_and_route.append(json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)

          end

          #Bus is only travelling on sundays and bank holidays
          if json["times"][i]["details"] == 'Only on Sundays and Bank Holidays' && (isSunday(date) || isBankHoliday(date))

            @time_and_route.append(json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)

          end

          #Bus is only travelling on sundays and bank holidays during college term, this string can be ommited, but I have it here for now just in case
          if json["times"][i]["details"] == 'Only on Sundays and Bank Holidays, COLLEGE TERM ONLY' && (isSunday(date) || isBankHoliday(date))

            @time_and_route.append(json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)

          end

          #Bus travels on weekdays only
          if json["times"][i]["details"] == 'Monday to Friday only' && isWeekday(date)

            @time_and_route.append(json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)

          end

          #Bus travels on weekends and bank holidays only
          if json["times"][i]["details"] == 'Weekends or Bank Holidays only' && (isSunday(date) || isSaturday(date) || isBankHoliday(date))

            @time_and_route.append(json["times"][i]["time"])
            @time_and_route.append(json["times"][i]["journey#"])
            @travel_times.append(@time_and_route)

          end

          #Bus travels 10 mins later on weekends, so check if it's saturday or sunday and
          #change time by adding 10 mins to it. This is handled with TIME object variable. Works fine.
          if json["times"][i]["details"] == 'Everyday, 10 mins later at weekend'
            if (isSaturday(date) || isSunday(date))
              time = Time.parse(json["times"][i]["time"]) + 10*60
              time = time.strftime("%H:%M")

              @time_and_route.append(time)
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            else

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

          end

          #Bus travels 15 mins later on saturdays and not on sundays or bank holidays
          #Again time changed using TIME object methods
          # 15*60 is equivalent to 15 minutes (15 * 60 seconds)
          if json["times"][i]["details"] == 'Not on Sundays or Bank Holidays, 15 mins later on Saturday' && !(isSunday(date) || isBankHoliday(date))

            if isSaturday(date)
              time = Time.parse(json["times"][i]["time"]) + 15*60
              time = time.strftime("%H:%M")

              @time_and_route.append(time)
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            else

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end
          end

          #Bus travels 10 mins later on saturdays and not on sundays or bank holidays
          #Again time changed using TIME object methods
          # 10*60 is equivalent to 10 minutes (10 * 60 seconds)
          if json["times"][i]["details"] == 'Not on Sundays or Bank Holidays, 10 mins later on Saturday' && !(isSunday(date) || isBankHoliday(date))

            if isSaturday(date)
              time = Time.parse(json["times"][i]["time"]) + 10*60
              time = time.strftime("%H:%M")

              @time_and_route.append(time)
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            else

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end
          end

      end

      #***********************************************************************************
      #************************** IF DATE IS TODAY ***************************************
      #***********************************************************************************


      if parsed_date === current_date
        if Time.now < (timer - 60*60)
            #Bus travels everyday
            if json["times"][i]["details"] == 'Everyday'

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

              p "Time and route"
              p @time_and_route

              p "Travel times array"
              p @travel_times



            end

            #Bus travels everyday, but doesn't server Dublin City stops
            if json["times"][i]["details"] == 'Everyday, No Dublin city stops served'

              @time_and_route.append('*'+json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

            #Bus isn't travelling on sundays or bank holidays
            if json["times"][i]["details"] == 'Not on Sundays or Bank Holidays' && !(isSunday(date) || isBankHoliday(date))

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

            #Bus is only travelling on sundays and bank holidays
            if json["times"][i]["details"] == 'Only on Sundays and Bank Holidays' && (isSunday(date) || isBankHoliday(date))

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

            #Bus is only travelling on sundays and bank holidays during college term, this string can be ommited, but I have it here for now just in case
            if json["times"][i]["details"] == 'Only on Sundays and Bank Holidays, COLLEGE TERM ONLY' && (isSunday(date) || isBankHoliday(date))

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

            #Bus travels on weekdays only
            if json["times"][i]["details"] == 'Monday to Friday only' && isWeekday(date)

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

            #Bus travels on weekends and bank holidays only
            if json["times"][i]["details"] == 'Weekends or Bank Holidays only' && (isSunday(date) || isSaturday(date) || isBankHoliday(date))

              @time_and_route.append(json["times"][i]["time"])
              @time_and_route.append(json["times"][i]["journey#"])
              @travel_times.append(@time_and_route)

            end

            #Bus travels 10 mins later on weekends, so check if it's saturday or sunday and
            #change time by adding 10 mins to it. This is handled with TIME object variable. Works fine.
            if json["times"][i]["details"] == 'Everyday, 10 mins later at weekend'
              if (isSaturday(date) || isSunday(date))
                time = Time.parse(json["times"][i]["time"]) + 10*60
                time = time.strftime("%H:%M")

                @time_and_route.append(time)
                @time_and_route.append(json["times"][i]["journey#"])
                @travel_times.append(@time_and_route)

              else

                @time_and_route.append(json["times"][i]["time"])
                @time_and_route.append(json["times"][i]["journey#"])
                @travel_times.append(@time_and_route)

              end

            end

            #Bus travels 15 mins later on saturdays and not on sundays or bank holidays
            #Again time changed using TIME object methods
            # 15*60 is equivalent to 15 minutes (15 * 60 seconds)
            if json["times"][i]["details"] == 'Not on Sundays or Bank Holidays, 15 mins later on Saturday' && !(isSunday(date) || isBankHoliday(date))

              if isSaturday(date)
                time = Time.parse(json["times"][i]["time"]) + 15*60
                time = time.strftime("%H:%M")

                @time_and_route.append(time)
                @time_and_route.append(json["times"][i]["journey#"])
                @travel_times.append(@time_and_route)

              else

                @time_and_route.append(json["times"][i]["time"])
                @time_and_route.append(json["times"][i]["journey#"])
                @travel_times.append(@time_and_route)

              end
            end

            #Bus travels 10 mins later on saturdays and not on sundays or bank holidays
            #Again time changed using TIME object methods
            # 10*60 is equivalent to 10 minutes (10 * 60 seconds)
            if json["times"][i]["details"] == 'Not on Sundays or Bank Holidays, 10 mins later on Saturday' && !(isSunday(date) || isBankHoliday(date))

              if isSaturday(date)
                time = Time.parse(json["times"][i]["time"]) + 10*60
                time = time.strftime("%H:%M")

                @time_and_route.append(time)
                @time_and_route.append(json["times"][i]["journey#"])
                @travel_times.append(@time_and_route)

              else

                @time_and_route.append(json["times"][i]["time"])
                @time_and_route.append(json["times"][i]["journey#"])
                @travel_times.append(@time_and_route)

              end
            end
        end
      end

      #***********************************************************************************
      #************************** IF DATE IS IN THE PAST *********************************
      #***********************************************************************************


      if parsed_date < current_date
        @past_date = true
      end

     end
  end


  def available_times

    p "Available_times Called"

    date = Date.parse(params[:date])
    origin = params[:origin]
    destination = params[:destination]

    # Used to store all possible times
    @travel_times = Array.new


    json = nil


    # Any bus stop starting between Arklow and Wexford going towards Wexford
    if origin == 'Arklow'


     json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/7.json').read)

      if destination == 'Gorey' || destination == 'Camolin' || destination == 'Ferns' || destination == 'Enniscorthy' || destination == 'Oylgate' || destination == 'Wexford'
        json = json[1]
      else
        json = json[0]
      end
    end

    if origin == 'Camolin'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/5.json').read)
      if destination == 'Ferns' || destination == 'Enniscorthy' || destination == 'Oylgate' || destination == 'Wexford'
        json = json[1]
      else
        json = json[0]
      end
    end

    if origin == 'Cherrywood/Wyattville (Luas)'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/16.json').read)
      json = json[1]
    end

    if origin == 'North Wall (Clarion Hotel)'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/11.json').read)
      json = json[1]
    end

    if origin == 'Wexford'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/1.json').read)
      json = json[0]
    end

    if origin == 'Oylgate'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/2.json').read)

      if destination == 'Wexford'
        json = json[1]
      else
        json = json[0]
      end
    end

    if origin == 'Enniscorthy'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/3.json').read)
      if destination == 'Oylgate' || destination == 'Wexford'
        json = json[1]
      else
        json = json[0]
      end
    end

    if origin == 'Ferns'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/4.json').read)
      if destination == 'Enniscorthy' || destination == 'Oylgate' || destination == 'Wexford'
        json = json[1]
      else
        json = json[0]
      end
    end

    if origin == 'Gorey'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/6.json').read)
      if destination == 'Camolin' || destination == 'Ferns' || destination == 'Enniscorthy' || destination == 'Oylgate' || destination == 'Wexford'
        json = json[1]
      else
        json = json[0]
      end
    end

    if origin == 'Dublin Airport'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/12.json').read)
      json = json[1]
    end

    if origin == 'Custom House Quay'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/13.json').read)
      json = json[0]
    end

    if origin == 'Georges Quay'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/13.json').read)
      json = json[0]
    end

    if origin == 'Lr Merrion St (Davenport)'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/14.json').read)
      json = json[0]
    end

    if origin == 'Montrose Hotel (UCD)'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/15.json').read)
      json = json[0]
    end

    if origin == 'Leeson Street Upper'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/17.json').read)
      json = json[1]
    end

    if origin == 'Swords Road (Jct Collins Ave)'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/18.json').read)
      json = json[0]
    end

    if origin == 'Kilmacanogue'
      json = ActiveSupport::JSON.decode(open('http://www.littleladybird.ie/JSON/19.json').read)
      json = json[0]
    end

    BusesTravelThisDay(date, json)



  end

  def show_seats

    # Convert string to array
    time_and_route_local = JSON.parse(params[:time_and_route])
    @time = time_and_route_local[0]
    @route = time_and_route_local[1]
    @date = params[:date]
    @origin = params[:origin]
    @destination = params[:destination]

    @commuter = Commuter.find_by_username(params[:current_commuter])


    @user = @commuter.username

    # Check if there exists reservation for the same date and time
    same_date_check = Reservation.all.where(:user => @commuter.username, :destination => @destination, :date => @date).exists?

    @message_if_booked_before = false
    @message_if_not_booked = false


    # User trying to book this route for different times twice
    if same_date_check
      @message_if_booked_before = true

      def change_time


        @time = params[:time]
        @route = params[:route]
        @date = params[:date]
        @origin = params[:origin]
        @destination = params[:destination]
        user = params[:user]

        @commuter = Commuter.find_by_username(user)




        Reservation.delete(Reservation.where(:user => user, :destination => @destination, :date => @date))

        res = Reservation.new

        res.date = @date
        res.time = @time
        res.route = @route
        res.origin = @origin
        res.destination = @destination
        res.user = user
        res.save



      CommuterMailer.booking_confirmation_email(@commuter, @origin, @destination, @time, @date).deliver

      end


    # If this route was not booked before show reservation summary and send email
    else

      @message_if_not_booked = true

      res = Reservation.new
      res.date = @date
      res.time = @time
      res.route = @route
      res.origin = @origin
      res.destination = @destination
      res.user = @commuter.username
      res.save

      CommuterMailer.booking_confirmation_email(@commuter, @origin, @destination, @time, @date).deliver

    end
  end










end