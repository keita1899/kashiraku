class MaterialsController < ApplicationController
  def index
    @materials = current_user.materials.includes(:allergens).order(created_at: :desc)
  end

  def new
    @material = current_user.materials.build
    set_allergens
  end

  def create
    @material = current_user.materials.build(material_params)
    if @material.save
      redirect_to materials_path, notice: "原材料を登録しました"
    else
      set_allergens
      render :new, status: :unprocessable_content
    end
  end

  def edit
    @material = current_user.materials.find(params[:id])
    set_allergens
  end

  def update
    @material = current_user.materials.find(params[:id])
    if @material.update(material_params)
      redirect_to materials_path, notice: "原材料を更新しました"
    else
      set_allergens
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @material = current_user.materials.find(params[:id])
    if @material.destroy
      redirect_to materials_path, notice: "原材料を削除しました"
    else
      redirect_to materials_path, alert: "原材料の削除に失敗しました"
    end
  end

  private

  def set_allergens
    @required_allergens = Allergen.required_items
    @recommended_allergens = Allergen.recommended_items
  end

  def material_params
    params.require(:material).permit(:name, :display_name, :purchase_price, :purchase_quantity, :unit, :additive,
                                     :energy, :protein, :fat, :carbohydrate, :salt, allergen_ids: [])
  end
end
