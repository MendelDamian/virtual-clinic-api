Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    registrations: 'api/v1/registrations',
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :professions, only: %i[index create]
      resources :doctors, only: %i[] do
        member do
          get :professions
        end
      end
    end
  end
end
