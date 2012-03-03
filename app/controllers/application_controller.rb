class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :set_time_zone, :except => [:about, :authenticate]

  private

  def set_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end

  def after_sign_in_path_for(resource)
    if current_user.has_random_password && !flash[:alert].blank?
      edit_user_registration_path
    else
      super
    end
  end
end
