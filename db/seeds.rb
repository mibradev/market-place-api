1.upto(3) do |user_i|
  user = User.create!(email: "user#{user_i}@example.com", password: "secret")

  1.upto(3) do |product_i|
    user.products.create!(title: "Product #{user_i}/#{product_i}")
  end
end
