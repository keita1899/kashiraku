class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to root_path, alert: "ログインしてください"
    end
  end
end
