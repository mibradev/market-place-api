require 'test_helper'

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)

    @order_params = {
      order: {
        product_ids: [products(:one).id, products(:two).id],
        total: 50
      }
    }
  end

  test "should not show orders if unauthorized" do
    get api_v1_orders_url
    assert_response :forbidden
  end

  test "should show orders" do
    get api_v1_orders_url, headers: { "Authorization" => JsonWebToken.encode(user_id: @order.user_id) }
    assert_response :ok
    assert_equal @order.user.orders.count, response.parsed_body.length
  end

  test "should not show order if unauthorized" do
    get api_v1_order_url(@order)
    assert_response :forbidden
  end

  test "should show order" do
    get api_v1_order_url(@order), headers: { "Authorization" => JsonWebToken.encode(user_id: @order.user_id) }
    assert_response :ok
    assert_equal @order.products.first.title, response.parsed_body["included"][0]["attributes"]["title"]
  end

  test "should not create order if unauthorized" do
    assert_no_difference("Order.count", 1) do
      post api_v1_orders_url(@order), params: @order_params
    end

    assert_response :forbidden
  end

  test "should create order" do
    assert_equal 0, ActionMailer::Base.deliveries.count

    assert_difference("Order.count", 1) do
      post api_v1_orders_url(@order),
        params: @order_params,
        headers: { "Authorization" => JsonWebToken.encode(user_id: @order.user_id) }
    end

    assert_equal 1, ActionMailer::Base.deliveries.count
    assert_response :created
  end
end
