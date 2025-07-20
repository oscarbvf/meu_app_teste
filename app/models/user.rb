class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :sessions, dependent: :destroy
  has_many :comments, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }
end
