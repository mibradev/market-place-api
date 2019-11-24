require 'test_helper'

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should show products" do
    get api_v1_products_url
    assert_response :ok

    Product.all.each_with_index do |product, i|
      assert_equal product.title, response.parsed_body["data"][i]["attributes"]["title"]
      assert_equal product.price.to_s, response.parsed_body["data"][i]["attributes"]["price"]
      assert_equal product.published, response.parsed_body["data"][i]["attributes"]["published"]
    end
  end

  test "should show product" do
    get api_v1_product_url(@product)
    assert_response :ok
    assert_equal @product.title, response.parsed_body.dig("data", "attributes", "title")
    assert_equal @product.price.to_s, response.parsed_body.dig("data", "attributes", "price")
    assert_equal @product.published, response.parsed_body.dig("data", "attributes", "published")
    assert_equal @product.user.id.to_s, response.parsed_body.dig("data", "relationships", "user", "data", "id")
    assert_equal @product.user.email, response.parsed_body.dig("included", 0, "attributes", "email")
  end

  test "should not create product if unauthorized" do
    assert_no_difference("Product.count") do
      post api_v1_products_url, params: { product: { title: @product.title, price: @product.price, published: @product.published } }
    end

    assert_response :forbidden
  end

  test "should not create product with invalid params" do
    assert_no_difference("Product.count") do
      post api_v1_products_url,
        params: { product: { title: nil, price: nil, published: @product.published } },
        headers: { "Authorization" => JsonWebToken.encode(user_id: @product.user_id) }
    end

    assert_response :unprocessable_entity
    assert_equal ["title", "price"], response.parsed_body["errors"].keys
  end

  test "should create product" do
    assert_difference("Product.count") do
      post api_v1_products_url,
        params: { product: { title: @product.title, price: @product.price, published: @product.published } },
        headers: { "Authorization" => JsonWebToken.encode(user_id: @product.user_id) }
    end

    assert_response :created
    assert_equal @product.title, response.parsed_body["data"]["attributes"]["title"]
    assert_equal @product.price.to_s, response.parsed_body["data"]["attributes"]["price"]
    assert_equal @product.published, response.parsed_body["data"]["attributes"]["published"]
  end

  test "should not update product if unauthorized" do
    assert_no_difference("Product.count") do
      patch api_v1_product_url(@product),
        params: { product: { title: @product.title } },
        headers: { "Authorization" => JsonWebToken.encode(user_id: users(:two).id) }
    end

    assert_response :forbidden
  end

  test "should not update product with invalid params" do
    assert_no_difference("Product.count") do
      patch api_v1_product_url(@product),
        params: { product: { title: nil } },
        headers: { "Authorization" => JsonWebToken.encode(user_id: @product.user_id) }
    end

    assert_response :unprocessable_entity
    assert_equal ["title"], response.parsed_body["errors"].keys
  end

  test "should update product" do
    patch api_v1_product_url(@product),
      params: { product: { title: "#{@product.title}-2" } },
      headers: { "Authorization" => JsonWebToken.encode(user_id: @product.user_id) }

    assert_response :ok
    assert_equal "#{@product.title}-2", response.parsed_body["data"]["attributes"]["title"]
  end

  test "should not destroy product if unauthorized" do
    assert_no_difference("Product.count") do
      delete api_v1_product_url(@product),
        headers: { "Authorization" => JsonWebToken.encode(user_id: users(:two).id) }
    end

    assert_response :forbidden
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete api_v1_product_url(@product),
        headers: { "Authorization" => JsonWebToken.encode(user_id: @product.user_id) }
    end

    assert_response :no_content
  end
end
