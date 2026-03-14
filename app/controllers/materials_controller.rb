class MaterialsController < ApplicationController
  def index
    @materials = current_user.materials.order(created_at: :desc)
  end

  def new
    @material = current_user.materials.build
  end

  def create
    @material = current_user.materials.build(material_params)
    if @material.save
      redirect_to materials_path, notice: "原材料を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @material = current_user.materials.find(params[:id])
  end

  def update
    @material = current_user.materials.find(params[:id])
    if @material.update(material_params)
      redirect_to materials_path, notice: "原材料を更新しました"
    else
      render :edit, status: :unprocessable_entity
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

  def material_params
    params.require(:material).permit(:name, :display_name, :purchase_price, :purchase_quantity, :unit, :unit_price, :additive)
  end
end
