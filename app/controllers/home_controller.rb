class HomeController < ApplicationController
  def index
    if user_signed_in?
      respond_to do |format|
        format.html { redirect_to user_root_url }
        format.mobile { redirect_to user_root_url }
      end
    else
      respond_to do |format|
        format.html { render action: :index }
        format.mobile { redirect_to user_root_url }
      end
    end
  end
end