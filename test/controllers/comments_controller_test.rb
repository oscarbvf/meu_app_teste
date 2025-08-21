require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user
  end

  test "should create comment" do
    assert_difference("Comment.count", 1) do
      post post_comments_url(@post), params: { comment: { body: "Test comment" } }
    end

    assert_redirected_to post_url(@post)
  end

  test "should destroy comment" do
    comment = Comment.create!(body: "Comment to be deleted", post: @post, user: @user)

    assert_difference("Comment.count", -1) do
      delete post_comment_url(@post, comment)
    end

    assert_redirected_to post_url(@post)
  end
end
