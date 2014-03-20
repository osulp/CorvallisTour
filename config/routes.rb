CorvallisTour::Application.routes.draw do
  root "home#index"

  resources :locations, :format => 'json', :only => :index do
    resources :images, :format => 'json', :only => :index
  end

  namespace :admin do
    resources :locations, :except => :show do
      resources :images
      member do
        get 'move/:direction', :action => 'move', :as => 'move'
      end
    end
  end
end
