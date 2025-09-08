class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :body, presence: true

  # Send automatically for all listeners
  after_create_commit  -> { broadcast_append_to [post, :comments], target: "comments" }
  after_update_commit  -> { broadcast_replace_to [post, :comments] }
  after_destroy_commit -> { broadcast_remove_to [post, :comments] }
end
