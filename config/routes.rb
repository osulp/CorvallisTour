CorvallisTour::Application.routes.draw do
  root "home#index"
  namespace :admin do
    resources :locations, :except => :show do
      resources :images
    end
  end
end
