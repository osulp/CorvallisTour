CorvallisTour::Application.routes.draw do
  root "home#index"
  scope module: 'admin' do
    resources :locations, :except => :show do
      resources :images
    end
  end
end
