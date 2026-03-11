class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      redirect_to root_path, alert: "ログインに失敗しました"
    end
  end

  def failure
    redirect_to root_path, alert: "ログインに失敗しました"
  end
end
