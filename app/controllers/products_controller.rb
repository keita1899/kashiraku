class ProductsController < ApplicationController
  def index
    @products = current_user.products.order(created_at: :desc)
  end

  def new
    @product = current_user.products.build
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to products_path, notice: "商品を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = current_user.products.find(params[:id])
  end

  def update
    @product = current_user.products.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "商品を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :category, :sales_price)
  end
end
