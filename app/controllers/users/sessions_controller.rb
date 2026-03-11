class Users::SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def destroy
    sign_out(current_user)
    redirect_to root_path, notice: "ログアウトしました"
  end
end
