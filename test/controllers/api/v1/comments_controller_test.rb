require "test_helper"

class Api::V1::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @comment = comments(:one)
    # Get an user
    @user = users(:one)

    # Generate valid JWT token for tests
    payload = { user_id: @user.id, exp: 1.hour.from_now.to_i }
    secret = Rails.application.credentials.jwt_secret
    @token = JWT.encode(payload, secret, "HS256")

    @auth_headers = { "Authorization" => "Bearer #{@token}" }
  end

  test "should get index of comments for post" do
    get api_v1_post_comments_url(@post), headers: @auth_headers, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert body["data"].is_a?(Array)
  end

  test "should show comment" do
    get api_v1_post_comment_url(@post, @comment), headers: @auth_headers, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal @comment.body, body["data"]["body"]
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post api_v1_post_comments_url(@post),
           params: { comment: { body: "New test comment" } },
           headers: @auth_headers,
           as: :json
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "New test comment", body["data"]["body"]
  end

  test "should update comment by owner" do
    patch api_v1_post_comment_url(@post, @comment),
          params: { comment: { body: "Updated by test" } },
          headers: @auth_headers,
          as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "Updated by test", body["data"]["body"]
  end

  test "should not update comment by another user" do
    other_user = users(:two)
    payload = { user_id: other_user.id, exp: 1.hour.from_now.to_i }
    token = JWT.encode(payload, Rails.application.credentials.jwt_secret, "HS256")

    patch api_v1_post_comment_url(@post, @comment),
          params: { comment: { body: "Operation now allowed" } },
          headers: { "Authorization" => "Bearer #{token}" },
          as: :json
    assert_response :forbidden
  end

  test "should destroy comment by owner" do
    assert_difference("Comment.count", -1) do
      delete api_v1_post_comment_url(@post, @comment),
             headers: @auth_headers,
             as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "Comment successfully deleted.", body["data"]["message"]
  end

  test "should not destroy comment by another user" do
    other_user = users(:two)
    payload = { user_id: other_user.id, exp: 1.hour.from_now.to_i }
    token = JWT.encode(payload, Rails.application.credentials.jwt_secret, "HS256")

    delete api_v1_post_comment_url(@post, @comment),
           headers: { "Authorization" => "Bearer #{token}" },
           as: :json
    assert_response :forbidden
  end

  test "should not access index with invalid token" do
    get api_v1_post_comments_url(@post), headers: @invalid_headers, as: :json
    assert_response :unauthorized
  end

  test "should not access show with invalid token" do
    get api_v1_post_comment_url(@post, @comment), headers: @invalid_headers, as: :json
    assert_response :unauthorized
  end

  test "should not create comment with invalid token" do
    post api_v1_post_comments_url(@post),
         params: { comment: { body: "Falha teste" } },
         headers: @invalid_headers,
         as: :json
    assert_response :unauthorized
  end

  test "should not update comment with invalid token" do
    patch api_v1_post_comment_url(@post, @comment),
          params: { comment: { body: "Falha teste" } },
          headers: @invalid_headers,
          as: :json
    assert_response :unauthorized
  end

  test "should not destroy comment with invalid token" do
    delete api_v1_post_comment_url(@post, @comment),
           headers: @invalid_headers,
           as: :json
    assert_response :unauthorized
  end
end
