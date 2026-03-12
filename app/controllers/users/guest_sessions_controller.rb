class Users::GuestSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストとしてログインしました"
  end
end
