class SettingsController < ApplicationController
  def show
  end

  def update
    if current_user.update(manufacturer_params)
      redirect_to settings_path, notice: "製造者情報を更新しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def manufacturer_params
    params.require(:user).permit(:manufacturer_name, :manufacturer_address)
  end
end
