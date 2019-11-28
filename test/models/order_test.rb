require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
  end

  test "validity" do
    assert @order.valid?
  end

  test "total presence" do
    @order.total = nil
    assert_not @order.valid?
    assert_equal [I18n.t("errors.messages.blank")], @order.errors.messages[:total]
  end

  test "total minimum value" do
    @order.total = -1
    assert_not @order.valid?
    assert_equal [I18n.t("errors.messages.greater_than_or_equal_to", count: 0.0)], @order.errors.messages[:total]
  end

  test "total maximum value" do
    @order.total = 100000.00
    assert_not @order.valid?
    assert_equal [I18n.t("errors.messages.less_than_or_equal_to", count: 99999.99)], @order.errors.messages[:total]
  end

  test "total scale" do
    @order.total = 0.994
    assert_equal 0.99, @order.total
  end
end
