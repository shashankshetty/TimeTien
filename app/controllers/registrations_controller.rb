class RegistrationsController < Devise::RegistrationsController
  #source: http://www.communityguides.eu/articles/11
  def update
    if params[resource_name][:country_id]
      resource.country_id = params[resource_name][:country_id] if Country.find_by_id(params[resource_name][:country_id])
    end

    if current_user.has_random_password
      if params[resource_name][:password].blank?
        params[resource_name].delete(:password)
        params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank?
      else
        # if the user wants to set a password we set has_random_password to false for the future
        params[resource_name][:has_random_password] = false
      end

      # code from the original devise controller, instead of update_with_password we use update_attributes
      if resource.update_attributes(params[resource_name])
        set_flash_message :notice, :updated
        sign_in resource_name, resource
        redirect_to after_update_path_for(resource)
      else
        clean_up_passwords(resource)
        render_with_scope :edit
      end
    else
      super
    end
  end

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end
end