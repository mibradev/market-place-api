class Api::V1::ProductsController < ApplicationController
  include Paginable

  before_action :set_product, only: [:show, :update, :destroy]
  before_action :authenticate!, only: :create
  before_action :check_owner, only: [:update, :destroy]

  def index
    products = Product.includes(:user).page(current_page).per(per_page).search(params)
    options = get_links_serializer_options("api_v1_products_path", products)
    options[:include] = [:user]
    render json: ProductSerializer.new(products, options).serializable_hash
  end

  def show
    render json: ProductSerializer.new(@product, include: [:user]).serializable_hash
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      render json: ProductSerializer.new(@product).serializable_hash, status: :created
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:title, :price, :published)
    end

    def check_owner
      head :forbidden unless @product.user_id == current_user&.id
    end
end
