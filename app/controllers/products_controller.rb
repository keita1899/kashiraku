class ProductsController < ApplicationController
  def index
    @products = current_user.products.includes(product_materials: :material).order(created_at: :desc)
  end

  def new
    @product = current_user.products.build
    @product.product_materials.build
    set_materials
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to products_path, notice: "商品を登録しました"
    else
      set_materials
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @product = current_user.products.includes(product_materials: :material).find(params[:id])
    set_materials
  end

  def update
    @product = current_user.products.includes(product_materials: :material).find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, notice: "商品を更新しました"
    else
      set_materials
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @product = current_user.products.find(params[:id])
    if @product.destroy
      redirect_to products_path, notice: "商品を削除しました"
    else
      redirect_to products_path, alert: "商品の削除に失敗しました"
    end
  end

  private

  def set_materials
    @materials = current_user.materials.order(:name)
  end

  def product_params
    params.require(:product).permit(
      :name, :category, :sales_price,
      product_materials_attributes: [ :id, :material_id, :quantity, :note, :_destroy ]
    )
  end
end
