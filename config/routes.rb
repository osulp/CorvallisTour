CorvallisTour::Application.routes.draw do
  scope module: 'admin' do
    resources :locations, :except => :show
  end
end
