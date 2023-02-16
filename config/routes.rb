Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    registrations: 'api/v1/registrations',
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :professions, only: %i[index create]
      resources :work_plans, only: %i[create update destroy]
      resources :procedures, only: %i[index create update destroy]
      resources :appointments, only: [] do
        get 'availability', on: :collection
      end

      resources :doctors, only: :index do
        scope module: :doctors do
          resources :appointments, only: :index
          resources :professions, only: :index
          resources :work_plans, only: :index
          resources :procedures, only: :index
        end
      end

      resources :patients, only: :index do
        scope module: :patients do
          resources :appointments, only: :index
        end
      end
    end
  end
end
