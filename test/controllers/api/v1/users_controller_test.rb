require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should show user" do
    get api_v1_user_url(@user)
    assert_response :ok
    assert_equal @user.as_json, response.parsed_body
  end

  test "should create user" do
    assert_difference("User.count") do
      post api_v1_users_url, params: { user: { email: "user@example.com", password: "secret" } }
    end

    assert_response :created
    assert_equal "user@example.com", response.parsed_body["email"]
  end

  test "should update user" do
    patch api_v1_user_url(@user), params: { user: { email: "user@example.com", password: "secret" } }
    assert_response :ok
    assert_equal "user@example.com", response.parsed_body["email"]
  end

  test "should not create user with taken email" do
    assert_no_difference("User.count") do
      post api_v1_users_url, params: { user: { email: @user.email, password: "secret" } }
    end

    assert_response :unprocessable_entity
    assert_equal [I18n.t("errors.messages.taken")], response.parsed_body["errors"]["email"]
  end

  test "should not update user with invalid params" do
    patch api_v1_user_url(@user), params: { user: { email: "invalid", password: "secret" } }
    assert_response :unprocessable_entity
    assert_equal [I18n.t("errors.messages.invalid")], response.parsed_body["errors"]["email"]
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete api_v1_user_url(@user)
    end

    assert_response :no_content
  end
end
