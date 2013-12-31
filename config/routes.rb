CorvallisTour::Application.routes.draw do
  root "home#index"
  get "home/get_waypoints", :format => 'json'
  get "home/get_images/:id", :format => 'json', :to => "home#get_images"
  scope module: 'admin' do
    resources :locations, :except => :show do
      resources :images
    end
  end
end
