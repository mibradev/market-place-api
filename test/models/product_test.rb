require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product1 = products(:one)
  end

  test "defaults" do
    @product = Product.new
    assert_equal 0.0, @product.price
    assert_not @product.published?
  end

  test "validity" do
    assert @product1.valid?
  end

  test "title presence" do
    @product1.title = nil
    assert_not @product1.valid?
    assert_equal [I18n.t("errors.messages.blank")], @product1.errors.messages[:title]
  end

  test "price presence" do
    @product1.price = nil
    assert_not @product1.valid?
    assert_equal [I18n.t("errors.messages.blank")], @product1.errors.messages[:price]
  end

  test "price minimum value" do
    @product1.price = -1
    assert_not @product1.valid?
    assert_equal [I18n.t("errors.messages.greater_than_or_equal_to", count: 0.0)], @product1.errors.messages[:price]
  end

  test "price maximum value" do
    @product1.price = 10000.00
    assert_not @product1.valid?
    assert_equal [I18n.t("errors.messages.less_than_or_equal_to", count: 9999.99)], @product1.errors.messages[:price]
  end

  test "price scale" do
    @product1.price = 0.994
    assert_equal 0.99, @product1.price
  end

  test "user presence" do
    @product1.user_id = nil
    assert_not @product1.valid?
    assert_equal [I18n.t("errors.messages.required")], @product1.errors.messages[:user]
  end
end
