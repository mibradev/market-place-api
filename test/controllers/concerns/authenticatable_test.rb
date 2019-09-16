require 'test_helper'

class AuthenticatableTest < ActionDispatch::IntegrationTest
  class MockController < ActionController::API
    include Authenticatable
  end

  setup do
    @user = users(:one)
    @authentication = MockController.new
    @authentication.request = Struct.new(:headers).new({})
  end

  test "should get user" do
    @authentication.request.headers["Authorization"] = JsonWebToken.encode(user_id: @user.id)
    assert_equal @user.id, @authentication.current_user.id
  end

  test "should not get user without token" do
    assert_nil @authentication.current_user
  end
end
