class FoodLabelsController < ApplicationController
  def edit
    @product = current_user.products.includes(:allergens, product_materials: :material).find(params[:product_id])
  end
end
