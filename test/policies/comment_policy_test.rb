require "test_helper"

class CommentPolicyTest < ActiveSupport::TestCase
  def setup
    @user       = users(:one)
    @other_user = users(:two)
    @comment    = comments(:one) # belongs to @user in fixtures
  end

  test "scope should include all comments" do
    scope = Pundit.policy_scope!(@user, Comment)
    assert_includes scope, @comment
  end

  test "show should be permitted for any user" do
    policy = CommentPolicy.new(@user, @comment)
    assert policy.show?, "User should be able to view a comment"
  end

  test "create should be permitted for logged in user" do
    policy = CommentPolicy.new(@user, Comment.new)
    assert policy.create?, "User should be able to create a comment"
  end

  test "update should be permitted only for the comment owner" do
    assert CommentPolicy.new(@user, @comment).update?,
           "Owner should be able to update their comment"

    refute CommentPolicy.new(@other_user, @comment).update?,
           "Other users should not be able to update this comment"
  end

  test "destroy should be permitted only for the comment owner" do
    assert CommentPolicy.new(@user, @comment).destroy?,
           "Owner should be able to destroy their comment"

    refute CommentPolicy.new(@other_user, @comment).destroy?,
           "Other users should not be able to destroy this comment"
  end
end
