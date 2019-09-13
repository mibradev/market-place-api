1.upto(3) do |i|
  User.create!(email: "user#{i}@example.com", password: "secret")
end
