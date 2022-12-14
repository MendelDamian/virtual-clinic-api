Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    registrations: 'api/v1/registrations',
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :professions, only: %i[index create]
      resources :work_plans, only: %i[create update destroy]

      resources :procedures, only: %i[index create update destroy] do
        scope module: :procedures do
          resources :appointments, only: %i[] do
            get :availability, on: :collection
          end
        end
      end

      resources :doctors, only: %i[index] do
        scope module: :procedures do
          resources :professions, only: %i[index]
          resources :work_plans, only: %i[index]
        end
      end
    end
  end
end
