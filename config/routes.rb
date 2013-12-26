CorvallisTour::Application.routes.draw do
  scope module: 'admin' do
    resources :locations, :except => :show do
      resources :images
    end
  end
end
