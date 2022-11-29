Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
    registrations: 'api/v1/registrations',
  }

  namespace :api do
    namespace :v1 do
    end
  end
end
