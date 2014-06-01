# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base

  validates :user_name, :password_digest, :session_token, presence: :true

  before_validation :ensure_session_token

  def ensure_session_token
    self.session_token ||= SecureRandom.hex
  end

  def reset_session_token!
    self.session_token = SecureRandom.hex
    self.save!
    self.session_token
  end

  def password=(plain_text)
    @password = plain_text
    self.password_digest = BCrypt::Password.create(plain_text)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(:user_name => user_name)
    return user if user.try(:is_password?, password)
  end


end
