class Post < ApplicationRecord
  validates :titulo, presence: true
  validates :conteudo, presence: true

  has_many :comments, dependent: :destroy

  # Send automatically for all listeners
  after_create_commit -> { broadcast_append_to "posts" }
  after_update_commit -> { broadcast_replace_to "posts" }
  after_destroy_commit -> { broadcast_remove_to "posts" }
end
