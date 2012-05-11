class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid
  attr_accessor :email

  def get_auth_details_for_github(omniauth)
    auth_details = {
        'uid' => omniauth['extra']['raw_info']['id'].to_s || '',
        'provider' => omniauth['provider'] || '',
        'name' => omniauth['extra']['raw_info']['name'] || '',
        'email' => omniauth['extra']['raw_info']['email'] || ''
    }
    if auth_details['email'].blank?
      auth_details['has_error'] = true
      auth_details['error'] = "Public email address has not been set up for Github. Please set up public email address to authenticate with Github."
    end
    auth_details
  end

  def get_auth_details_for_google(omniauth)
    auth_details = {
        'uid' => omniauth['uid'].to_s || '',
        'provider' => omniauth['provider'] || '',
        'name' => omniauth['info']['name'] || '',
        'email' => omniauth['info']['email'] || ''
    }
    auth_details
  end

  def get_auth_details(service, omniauth)
    if service == 'github'
      auth_details = get_auth_details_for_github(omniauth)
    elsif service == 'google'
      auth_details = get_auth_details_for_google(omniauth)
    end
    auth_details
  end

  def get_authentication_provider_details(service, omniauth)
    if !service || !omniauth
      auth_details = {
          'has_error' => true,
          'error' => "Error encountered! Not a valid authentication service."
      }
      return auth_details
    end
    auth_details = get_auth_details(service, omniauth)
    if auth_details['uid'] == '' || auth_details['provider'] == ''
      auth_details['has_error'] = true
      auth_details['error'] = "Error encountered authenticating using #{service.capitalize}."
    end
    auth_details
  end
end
