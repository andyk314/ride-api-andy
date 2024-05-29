Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    resources :drivers, only: [:index, :create] do
      resources :rides, only: [:index, :create]
    end
  end
end
