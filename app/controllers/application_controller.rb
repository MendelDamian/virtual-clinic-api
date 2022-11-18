class ApplicationController < ActionController::API
  before_action :update_allowed_parameters, if: :devise_controller?
  respond_to :json

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password])
  end
end
