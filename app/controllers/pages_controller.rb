class PagesController < ApplicationController
  def about
    respond_to do |format|
      format.html
    end
  end
end