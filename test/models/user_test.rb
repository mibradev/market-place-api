require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user1 = users(:one)
  end

  test "validity" do
    assert @user1.valid?
  end

  test "email presence" do
    @user1.email = nil
    assert_not @user1.valid?
    assert_equal [I18n.t("errors.messages.blank")], @user1.errors.messages[:email]
  end

  test "email format" do
    assert_match /\A[^@\s]+@[^@\s]+\z/, @user1.email
    @user1.email = "invalid"
    assert_not @user1.valid?
    assert_equal [I18n.t("errors.messages.invalid")], @user1.errors.messages[:email]
  end

  test "email uniqueness" do
    @user2 = users(:two)
    @user2.email = @user1.email
    assert_not @user2.valid?
    assert_equal [I18n.t("errors.messages.taken")], @user2.errors.messages[:email]
  end

  test "password presence" do
    @user1.password = nil
    assert_not @user1.valid?
    assert_equal [I18n.t("errors.messages.blank")], @user1.errors.messages[:password]
  end

  test "password minimum length" do
    @user1.password = "p" * 5
    assert_not @user1.valid?
    assert_equal [I18n.t("errors.messages.too_short", count: 6)], @user1.errors.messages[:password]
  end

  test "password maximum length" do
    @user1.password = "p" * 73
    assert_not @user1.valid?
    assert_equal [I18n.t("errors.messages.too_long", count: 72)], @user1.errors.messages[:password]
  end

  test "password confirmation" do
    @user1.password = "secret"
    @user1.password_confirmation = "doesnotmatch"
    assert_not @user1.valid?
    assert_equal [I18n.t("errors.messages.confirmation", attribute: "Password")], @user1.errors.messages[:password_confirmation]
  end

  test "products destruction" do
    assert @user1.products.count > 0
    @user1.destroy
    assert_equal 0, @user1.products.count
  end
end
