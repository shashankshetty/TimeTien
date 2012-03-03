class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid
  attr_accessor :email

  def self.get_authentication_provider_details(service, omniauth)
    if !service || !omniauth
      auth_details = {
          'has_error' => true,
          'error' => "Error encountered! Not a valid authentication service."
      }
    else
      auth_details = {
          'uid' => omniauth['extra']['raw_info']['id'] || '',
          'provider' => omniauth['provider'] || '',
          'name' => omniauth['extra']['raw_info']['name'] || '',
          'email' => omniauth['extra']['raw_info']['email'] || ''
      }
      if auth_details['uid'] == '' || auth_details['provider'] == ''
        auth_details['has_error'] = true
        auth_details['error'] = "Error encountered authenticating using #{service.capitalize}."
      end
      if service == 'github' && auth_details['email'].blank?
        auth_details['has_error'] = true
        auth_details['error'] = "Public email address has not been set up for Github. Please set up public email address to authenticate with Github."
      end
    end
    auth_details
  end
end
