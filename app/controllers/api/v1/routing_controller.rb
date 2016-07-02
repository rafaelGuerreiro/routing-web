class Api::V1::RoutingController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: { status: 'ok', message: 'Success!' }
  end
end
