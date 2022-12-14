Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    registrations: 'api/v1/registrations',
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :professions, only: %i[index create]
      resources :procedures, only: %i[index create update destroy]
      resources :work_plans, only: %i[create update destroy]

      resources :doctors, only: %i[index] do
        resources :professions, only: %i[index], controller: 'doctors/professions'
        resources :work_plans, only: %i[index], controller: 'doctors/work_plans'

        resources :procedures, only: %i[index], controller: 'doctors/procedures' do
          resources :appointments, only: %i[], controller: 'doctors/procedures/appointments' do
            collection do
              get :availability
            end
          end
        end
      end
    end
  end
end
