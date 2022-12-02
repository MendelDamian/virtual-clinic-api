Rails.application.routes.draw do

  devise_for :users, defaults: { format: :json }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :procedures
    end
  end

end
