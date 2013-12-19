CorvallisTour::Application.routes.draw do
  resources :locations, :except => :show
end
