require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test1@example.com", password: "123456")
    @post = Post.create!(titulo: "My first post", conteudo: "Post content")
    @comment = Comment.new(body: "Comment for testing purposes", post: @post, user: @user)
  end

  test "Valid comment" do
    assert @comment.valid?
  end

  test "Not valid without content" do
    @comment.body = nil
    assert_not @comment.valid?
  end

  test "Not valid without a Post" do
    @comment.post = nil
    assert_not @comment.valid?
  end

  test "Not valid without a User" do
    @comment.user = nil
    assert_not @comment.valid?
  end
end
