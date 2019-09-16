require 'test_helper'

class Api::V1::TokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create token" do
    post api_v1_tokens_url, params: { user: { email: @user.email, password: "Pa$wrd01" } }
    assert_response :created
    assert_equal JsonWebToken.encode(user_id: @user.id), response.parsed_body["token"]
  end

  test "should not create token if email is invalid" do
    post api_v1_tokens_url, params: { user: { email: nil, password: "Pa$wrd01" } }
    assert_response :unauthorized
  end

  test "should not create token if password is invalid" do
    post api_v1_tokens_url, params: { user: { email: @user.email, password: nil } }
    assert_response :unauthorized
  end
end
