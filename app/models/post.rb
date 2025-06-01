class Post < ApplicationRecord
  validates :titulo, presence: true
  validates :conteudo, presence: true
end
