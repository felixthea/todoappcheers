require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :username, :password, :session_token

  validates :username, :password_digest, :session_token, presence: true

  before_validation :ensure_session_token

  def password=(secret)
    self.password_digest = BCrypt::Password.create(secret)
  end

  def has_password?(secret)
    BCrypt::Password.new(self.password_digest).is_password?(secret)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def self.find_by_credentials(username, secret)
    user = User.find_by_username(username)
    return nil if user.nil?
    return user if user.has_password?(secret)
    nil
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end
end
