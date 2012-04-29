# http://codingdaily.wordpress.com/2011/09/13/rails-devise-and-rspec/
module RequestMacros
  def login_devise_user(user)
    page.driver.post user_session_path, :user => {:email => user.email, :password => user.password}
  end
end
