class Post < ApplicationRecord
  validates :titulo, presence: true
  validates :conteudo, presence: true

  has_many :comments, dependent: :destroy
end
