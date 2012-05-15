class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications
    respond_to do |format|
      format.html
    end
  end

  def authenticate
    authentication = Authentication.new
    auth_details = authentication.get_authentication_provider_details(params[:service], request.env['omniauth.auth'])
    if auth_details['has_error']
      flash[:error] = auth_details['error']
      redirect_to user_signed_in? ? authentications_path : new_user_session_path
      return
    end
    auth = Authentication.find_by_provider_and_uid(auth_details['provider'], auth_details['uid'])
    if !user_signed_in?
      if auth
        flash[:success] = "Signed in successfully!"
        sign_in_and_redirect(:user, auth.user)
        return
      end
      user = User.find_by_email(auth_details['email'])
      if user
        user.authentications.create(:provider => auth_details['provider'], :uid => auth_details['uid'])
        flash[:success] = "Signed in successfully! #{auth_details['provider'].capitalize} has been linked to #{user.email} account."
        sign_in_and_redirect(:user, user)
        return
      end
      display_name = auth_details['name'] || ""
      display_name = display_name[0, 30] if !display_name.blank? && display_name.length > 30
      user = User.new(:email => auth_details['email'], :password => SecureRandom.hex(10), :has_random_password => true, :display_name => display_name)
      user.authentications.build(:provider => auth_details['provider'], :uid => auth_details['uid'])
      user.save!
      flash[:alert] = "Successfully created an account in TimeTien using #{auth_details['provider'].capitalize}. Update Display name and Time zone before continuing ..."
      sign_in_and_redirect(:user, user)
      return
    end
    if auth
      flash[:success] = "#{auth_details['provider']} is already linked to your account."
      redirect_to authentications_path
      return
    end
    current_user.authentications.create(:provider => auth_details['provider'], :uid => auth_details['uid'])
    flash[:success] = "#{auth_details['provider'].capitalize} has been added to your account."
    redirect_to authentications_path
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_path
  end
end
