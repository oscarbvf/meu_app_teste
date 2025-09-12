class Post < ApplicationRecord
  validates :titulo, presence: true
  validates :conteudo, presence: true

  has_many :comments, dependent: :destroy

  after_create_commit -> {
    broadcast_prepend_to "posts",
      target: "posts_list",
      partial: "posts/post_container",
      locals: { post: self }
  }

  after_update_commit -> {
    # Update content frame
    broadcast_replace_to "posts",
      target: "post_#{id}_content",
      partial: "posts/post_container",
      locals: { post: self }

    # Update actions frame
    broadcast_replace_to "posts",
      target: "post_#{id}_actions",
      partial: "posts/post_actions",
      locals: { post: self }
  }

  after_destroy_commit -> {
    broadcast_remove_to "posts", target: "post_#{id}_container"
  }

end
