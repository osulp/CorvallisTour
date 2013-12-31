CorvallisTour::Application.routes.draw do
  root "home#index"

  resources :waypoints, :format => 'json', :only => :index do
    get :images, :on => :member
  end

  scope module: 'admin' do
    resources :locations, :except => :show do
      resources :images
    end
  end
end
