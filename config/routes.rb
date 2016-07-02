Rails.application.routes.draw do
  devise_for :users
  resources :upload, only: [:new, :create]

  namespace :api do
    namespace :v1 do
      # Directs /api/v1/routing/* to Api::V1::RoutingController
      # (app/controllers/api/v1/routing_controller.rb)
      get 'routing' => 'routing#index'
    end
  end
end
