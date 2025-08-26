class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :sessions, dependent: :destroy
  has_many :comments, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  # Generate reset token with expiration (15 min)
  def generate_password_reset_token
    verifier.generate({ user_id: id, timestamp: Time.current.to_i })
  end

  # Search from token (nil if it's invalid or expired)
  def self.find_by_password_reset_token(token)
    data = verifier.verify(token, purpose: :password_reset, expires_in: 15.minutes)
    find(data[:user_id])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  private

  def self.verifier
    @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
  end

  def verifier
    self.class.verifier
  end
end
