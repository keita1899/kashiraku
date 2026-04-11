class ApplicationController < ActionController::Base
  include Pagy::Method

  rescue_from Pagy::RangeError, with: :redirect_to_first_page

  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def authenticate_user!
    unless user_signed_in?
      redirect_to root_path, alert: "ログインしてください"
    end
  end

  def redirect_to_first_page
    query = request.query_parameters.except("page")
    redirect_to query.empty? ? request.path : "#{request.path}?#{query.to_query}"
  end
end
