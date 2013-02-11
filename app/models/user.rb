class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password
  has_many :micro_posts 
  validates :password, presence: true, if: "hashed_password.blank?"
  validates :name, presence: true, length: { minimum: 4, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                     format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  before_save :encrypt_password

  def encrypt_password
    self.salt ||= Digest::SHA256.hexdigest("--#{Time.now.to_s}- -#{email}--")
    self.hashed_password ||= encrypt(password)
  end
  def self.authenticate(email, plain_text_password)
   @user = User.find_by_email(email)
   return nil unless @user 
   return nil unless @user.encrypt(plain_text_password) == @user.hashed_password
   return @user
end

def encrypt(raw_password)
    Digest::SHA256.hexdigest("--#{salt}--#{raw_password}--")
  end
end
