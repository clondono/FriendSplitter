class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :update_sanitized_params, if: :devise_controller?

	def update_sanitized_params
	  devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name)
	end
end
