Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :procedures
    end
  end

  devise_for :users, defaults: { format: :json }

end
