require "test_helper"

class PostPolicyTest < ActiveSupport::TestCase
  def setup
    @user       = users(:one)
    @other_user = users(:two)
    @post       = posts(:one) # make sure this post belongs to @user in fixtures
  end

  test "scope should include all posts" do
    scope = Pundit.policy_scope!(@user, Post)
    assert_includes scope, @post
  end

  test "show should be permitted for any user" do
    policy = PostPolicy.new(@user, @post)
    assert policy.show?, "User should be able to view a post"
  end

  test "create should be permitted for logged in user" do
    policy = PostPolicy.new(@user, Post.new)
    assert policy.create?, "User should be able to create a post"
  end

  test "update should be permitted for any logged in users" do
    assert PostPolicy.new(@user, @post).update?,
           "Owner should be able to update their post"

    assert PostPolicy.new(@other_user, @post).update?,
           "Other users should also be able to update this post"
  end

  test "destroy should be permitted for any logged in users" do
    assert PostPolicy.new(@user, @post).destroy?,
           "Owner should be able to destroy their post"

    assert PostPolicy.new(@other_user, @post).destroy?,
           "Other users should also be able to destroy this post"
  end
end
