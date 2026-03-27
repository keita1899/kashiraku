class AccountsController < ApplicationController
  def destroy
    if current_user.guest?
      redirect_to settings_path, alert: "ゲストアカウントは削除できません"
      return
    end

    current_user.destroy!
    reset_session
    redirect_to root_path, notice: "アカウントを削除しました"
  end
end
