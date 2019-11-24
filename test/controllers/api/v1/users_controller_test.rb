require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = users(:one)
  end

  test "should show user" do
    get api_v1_user_url(@user1)
    assert_response :ok
    assert_equal @user1.email, response.parsed_body.dig("data", "attributes", "email")
    assert_equal @user1.products.first.id.to_s, response.parsed_body.dig("data", "relationships", "products", "data", 0, "id")
    assert_equal @user1.products.first.title, response.parsed_body.dig("included", 0, "attributes", "title")
  end

  test "should create user" do
    assert_difference("User.count") do
      post api_v1_users_url, params: { user: { email: "user@example.com", password: "secret" } }
    end

    assert_response :created
    assert_equal "user@example.com", response.parsed_body["data"]["attributes"]["email"]
  end

  test "should update user" do
    patch api_v1_user_url(@user1),
      params: { user: { email: "user@example.com", password: "secret" } },
      headers: { "Authorization" => JsonWebToken.encode(user_id: @user1.id) }
    assert_response :ok
    assert_equal "user@example.com", response.parsed_body["data"]["attributes"]["email"]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete api_v1_user_url(@user1), headers: { "Authorization" => JsonWebToken.encode(user_id: @user1.id) }
    end

    assert_response :no_content
  end

  test "should not create user with taken email" do
    assert_no_difference("User.count") do
      post api_v1_users_url, params: { user: { email: @user1.email, password: "secret" } }
    end

    assert_response :unprocessable_entity
    assert_equal [I18n.t("errors.messages.taken")], response.parsed_body["errors"]["email"]
  end

  test "should not update user without token" do
    patch api_v1_user_url(@user1), params: { user: { email: @user1.email } }
    assert_response :forbidden
  end

  test "should not update other user" do
    @user2 = users(:two)
    patch api_v1_user_url(@user2),
      params: { user: { email: "user@example.com", password: "secret" } },
      headers: { "Authorization" => JsonWebToken.encode(user_id: @user1.id) }
    assert_response :forbidden
  end

  test "should not update user with invalid params" do
    patch api_v1_user_url(@user1),
      params: { user: { email: "invalid", password: "secret" } },
      headers: { "Authorization" => JsonWebToken.encode(user_id: @user1.id) }
    assert_response :unprocessable_entity
    assert_equal [I18n.t("errors.messages.invalid")], response.parsed_body["errors"]["email"]
  end

  test "should not destroy user without token" do
    delete api_v1_user_url(@user1)
    assert_response :forbidden
  end

  test "should not destroy other user" do
    @user2 = users(:two)
    delete api_v1_user_url(@user2), headers: { "Authorization" => JsonWebToken.encode(user_id: @user1.id) }
    assert_response :forbidden
  end
end
