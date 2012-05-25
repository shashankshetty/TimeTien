require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :github, 'b59c6687870545a923d6', '9bb88e4e8663fe46978bcd0cf9726ac5001e5c33'
  provider :github, 'dc0dbc0e7c0d68b5d524', '1d0718fdddecb0f04856be4a6773a273e762e385'
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

