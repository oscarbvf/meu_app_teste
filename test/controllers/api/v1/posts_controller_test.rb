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

  test "should login with valid credentials" do
    post api_v1_login_url,
         params: { email: @user.email, password: "password123" },
         as: :json

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal "success", body["status"]
    assert body["data"]["token"].present?, "JWT token should be present"
  end

  test "should not login with invalid password" do
    post api_v1_login_url,
         params: { email: @user.email, password: "wrongpass" },
         as: :json

    assert_response :unauthorized
    body = JSON.parse(response.body)

    assert_equal "error", body["status"]
    assert_equal "Invalid email or password", body["message"]
  end

  test "should not login with non-existent user" do
    post api_v1_login_url,
         params: { email: "fake@example.com", password: "password123" },
         as: :json

    assert_response :unauthorized
    body = JSON.parse(response.body)

    assert_equal "error", body["status"]
  end

  test "login should return a valid JWT token" do
    post api_v1_login_url,
         params: { email: @user.email, password: "password123" },
         as: :json

    body = JSON.parse(response.body)
    token = body["data"]["token"]

    decoded = JWT.decode(token, Rails.application.credentials.jwt_secret, true, { algorithm: "HS256" })
    payload = decoded.first

    assert_equal @user.id, payload["user_id"]
  end
end
