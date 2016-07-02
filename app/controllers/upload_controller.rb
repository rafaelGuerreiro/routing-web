class UploadController < ApplicationController
  before_action :authenticate_user!, except: :new

  def new
    redirect_to about_url unless user_signed_in?
  end

  def create
    # puts params['xlsx']
    redirect_to root_url, notice: 'The xlsx file was successfully uploaded.'
  end
end
