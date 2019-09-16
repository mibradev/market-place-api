require 'test_helper'

class JsonWebTokenTest < ActiveSupport::TestCase
  setup do
    @payload = { message: "hi" }
  end

  test "encode" do
    token = JsonWebToken.encode(@payload)
    assert JWT.decode(token, JsonWebToken::SECRET_KEY)
  end

  test "decode" do
    token = JWT.encode(@payload, JsonWebToken::SECRET_KEY)
    assert_equal JsonWebToken.decode(token), @payload.stringify_keys
  end

  test "default expiration date" do
    token = JsonWebToken.encode(@payload)
    assert_equal 1.days.from_now.to_i, JsonWebToken.decode(token)["exp"]
  end

  test "custom expiration date" do
    exp = 1.hour.from_now
    token = JsonWebToken.encode(@payload.merge(exp: exp))
    assert_equal exp.to_i, JsonWebToken.decode(token)["exp"]
  end
end
