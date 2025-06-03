class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Pundit::Authorization
  include NotificationsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def user_not_authorized
    flash[:alert] = "No estás autorizado para realizar esta acción."
    redirect_back(fallback_location: root_path)
  end
end
