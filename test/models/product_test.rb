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

  test "filtering by title" do
    assert_equal 2, Product.filter_by_title("tv").count
  end

  test "filtering by price" do
    assert_equal 3, Product.above_or_equal_to_price(200).count
    assert_equal 2, Product.below_or_equal_to_price(200).count
  end

  test "ordering by update date" do
    assert_not_equal products(:two), Product.recent.first
    products(:two).touch
    assert_equal products(:two), Product.recent.first
  end

  test "searching without parameters" do
    assert_equal Product.count, Product.search({}).count
  end

  test "searching for not existing product" do
    assert Product.search(keyword: "missing").empty?
  end

  test "searching for cheap tv" do
    assert_equal products(:tv2).id, Product.search(keyword: "tv", min_price: 50, max_price: 150).first.id
  end

  test "searching for ids" do
    assert_equal [@product1], Product.search(product_ids: [@product1.id])
  end
end
