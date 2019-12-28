1.upto(3) do |user_i|
  user = User.create!(email: "user#{user_i}@example.com", password: "secret")
  order = user.orders.build

  1.upto(3) do |product_i|
    product = user.products.create!(title: "Product #{user_i}/#{product_i}", price: 9.99)
    order.products << product
  end

  order.save
end
