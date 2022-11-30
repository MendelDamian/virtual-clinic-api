Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    registrations: 'api/v1/registrations',
  }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :professions, only: %i[index create] do
        get 'doctor/:doctor_id', on: :collection, to: 'professions#doctor'
      end
    end
  end
end
