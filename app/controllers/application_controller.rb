class ApplicationController < ActionController::Base
  include Pundit
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Force the user to redirect to the login page if the user was not logged in
  before_action :authenticate_user!

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    registration_params = [:name, :last_name, :email, :phone, :password, :password_confirmation, :is_walker, 
                           :role, :dogs, :experience]

    if params[:action] == 'update'
      params[:user][:is_walker] == "1" ? params[:user][:role] = "walker" : params[:user][:role] = "owner"
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      params[:user][:is_walker] == "1" ? params[:user][:role] = "walker" : params[:user][:role] = "owner"
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
end
