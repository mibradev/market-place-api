require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test "validity" do
    assert @order.valid?
  end

  test "total calculation" do
    order = Order.new user_id: @order.user_id
    order.products << products(:one)
    order.products << products(:two)
    order.save
    assert_equal (@product1.price + @product2.price), order.total
  end

  test "total scale" do
    @order.total = 0.994
    assert_equal 0.99, @order.total
  end

  test "creating placements" do
    @order.build_placements_with_product_ids_and_quantities [
      { product_id: @product1.id, quantity: 2 },
      { product_id: @product2.id, quantity: 3 }
    ]

    assert_difference("Placement.count", 2) do
      @order.save
    end
  end

  test "max quantity" do
    @order.placements << Placement.new(product_id: @product1.id, quantity: @product1.quantity + 1)
    assert_not @order.valid?
  end
end
