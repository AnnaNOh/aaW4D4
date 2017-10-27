class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token!

  attr_reader :password

  def self.find_by_credentials(username, password)
    @username = User.find_by(username: username)

    return nil if @username.nil?
    @username.is_password?(password) ? @username : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save
    self.session_token
  end

  def ensure_session_token!
    unless self.session_token
      self.session_token = SecureRandom::urlsafe_base64
    end 
  end


  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end


end
