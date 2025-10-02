class Post < ApplicationRecord
  validates :titulo, presence: true
  validates :conteudo, presence: true

  has_many :comments, dependent: :destroy

  after_create_commit do
    # general broadcast
    broadcast_prepend_to "posts",
      target: "posts_list",
      partial: "posts/post_broadcast",
      locals: { post: self }
    # logged users broadcast
    broadcast_replace_to "posts_logged_in",
      target: "post_#{id}_container",
      partial: "posts/post_container",
      locals: { post: self }
  end

  after_update_commit -> {
    # general broadcast
    broadcast_replace_to "posts",
      target: "post_#{id}_container",
      partial: "posts/post_broadcast",
      locals: { post: self }
    # logged users broadcast
    broadcast_replace_to "posts_logged_in",
      target: "post_#{id}_container",
      partial: "posts/post_container",
      locals: { post: self }
  }

  after_destroy_commit -> {
    broadcast_remove_to "posts", target: "post_#{id}_container"
  }

end
