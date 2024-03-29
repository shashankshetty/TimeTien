class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:index, :authenticate, :about, :privacy]
  before_filter :set_time_zone, :prepare_for_mobile

  private

  def set_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
    Chronic.time_class = Time.zone
  end

  def after_sign_in_path_for(resource)
    if current_user.has_random_password && !flash[:alert].blank?
      edit_user_registration_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource)
    if mobile_device?
      new_user_session_path
    else
      super
    end
  end

  def mobile_device?
    request.user_agent =~ /Mobile/
  end

  helper_method :mobile_device?

  def mobile_request?
    if session[:mobile_request]
      session[:mobile_request] == "1"
    else
      request.user_agent =~ /Mobile/
    end
  end

  helper_method :mobile_request?

  def prepare_for_mobile
    session[:mobile_request] = params[:mobile] if params[:mobile]
    if mobile_request?
      request.format = :mobile
    end
  end
end
