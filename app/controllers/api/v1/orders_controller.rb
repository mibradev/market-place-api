class Api::V1::OrdersController < ApplicationController
  before_action :authenticate!

  def index
    render json: OrderSerializer.new(current_user.orders).serializable_hash
  end
end
