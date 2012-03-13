class User < ActiveRecord::Base
  
  attr_accessible :username, :password, :password_confirmation

  validates_uniqueness_of :username
  validates_presence_of :password, :on => :create
  has_secure_password

  before_create { generate_token(:auth_token) }

  has_and_belongs_to_many :recipes
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
