class Reservation < ActiveRecord::Base
  attr_accessible :origin, :destination, :time, :date, :user

  validates_presence_of :origin
  validates_presence_of :destination
  validates_presence_of :time
  validates_presence_of :date
  validates_presence_of :user
end