# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: {
      message: "Signed up sucessfully",
      user: current_user,
    }, status: :ok
  end

  def register_failed
    render json: { error: "User already exists" }, status: :unprocessable_entity
  end

  # Add extra parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :company_id])
  end
end
