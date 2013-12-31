CorvallisTour::Application.routes.draw do
  root "home#index"

  resources :waypoints, :format => 'json', :only => :index do
    resources :images, :format => 'json', :only => :index
  end

  scope module: 'admin' do
    resources :locations, :except => :show do
      resources :images
    end
  end
end
