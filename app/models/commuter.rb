class Commuter < ActiveRecord::Base
  attr_accessible :email, :username, :password, :password_confirmation, :mobile,  :suspended, :isAdmin, :isDriver
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password


  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :username

  validates_uniqueness_of :email
  validates_uniqueness_of :username



  def initialize(attributes = {})
    super
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def self.authenticate_by_username(username, password)
    commuter = find_by_username(username)
    if commuter && commuter.password_hash == BCrypt::Engine.hash_secret(password, commuter.password_salt)
      commuter
    else
      nil
    end
  end


  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end


end
