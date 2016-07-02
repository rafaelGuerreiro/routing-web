class UploadController < ApplicationController
  def new
  end

  def create
    # puts params['xlsx']
    flash[:success] = 'The xlsx file was successfully uploaded.'
    redirect_to new_upload_url
  end
end
