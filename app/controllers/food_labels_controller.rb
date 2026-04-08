class FoodLabelsController < ApplicationController
  def edit
    @product = current_user.products.includes(:allergens, product_materials: :material).find(params[:product_id])
    @food_label = @product.food_label || @product.build_food_label
  end

  def update
    @product = current_user.products.includes(:allergens, product_materials: :material).find(params[:product_id])
    @food_label = @product.food_label || @product.build_food_label

    if @food_label.update(food_label_params)
      redirect_to edit_product_food_label_path(@product), notice: "食品表示ラベルを保存しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def food_label_params
    params.require(:food_label).permit(:product_name, :content_quantity, :expiration_date, :storage_method, :manufacturer_name, :manufacturer_address)
  end
end
