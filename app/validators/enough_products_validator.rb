class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |placement|
      product = placement.product

      if placement.quantity > product.quantity
        record.errors[product.title] << "is out of stock, just #{product.quantity} last"
      end
    end
  end
end
