class UploadController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    # puts params['xlsx']
    redirect_to root_url, notice: 'The xlsx file was successfully uploaded.'
  end
end
