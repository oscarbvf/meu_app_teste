require "test_helper"

class Api::V1::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one) # fixture exists
    @user = users(:one) # or new fixture user
    # Generates JWT for the test user
    payload = { user_id: @user.id, exp: 24.hours.from_now.to_i }
    secret = Rails.application.credentials.jwt_secret
    @jwt_token = JWT.encode(payload, secret, "HS256")
    # Header Authorization with Bearer token
    @auth_headers = { "Authorization" => "Bearer #{@jwt_token}" }
  end

  test "should get index" do
    get api_v1_posts_url, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert body["data"].is_a?(Array)
  end

  test "should show post" do
    get api_v1_post_url(@post), as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal @post.titulo, body["data"]["titulo"]
  end

  test "should create post with auth" do
    assert_difference("Post.count") do
      post api_v1_posts_url,
           params: { post: { titulo: "Created by test", conteudo: "Test content" } },
           headers: @auth_headers,
           as: :json
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "Created by test", body["data"]["titulo"]
  end

  test "should update post with auth" do
    patch api_v1_post_url(@post),
          params: { post: { titulo: "Updated by test" } },
          headers: @auth_headers,
          as: :json
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "Updated by test", body["data"]["titulo"]
  end

  test "should destroy post with auth" do
    assert_difference("Post.count", -1) do
      delete api_v1_post_url(@post), headers: @auth_headers, as: :json
    end

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "success", body["status"]
    assert_equal "Post successfully deleted.", body["data"]["message"]
  end

  test "should not create post with invalid token" do
    post api_v1_posts_url,
        params: { post: { titulo: "Fail test", conteudo: "Test" } }.to_json,
        headers: {
          "Authorization" => "Bearer invalidtoken",
          "Content-Type" => "application/json"
        }

    assert_response :unauthorized
  end
end
