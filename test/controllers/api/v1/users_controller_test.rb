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
end
