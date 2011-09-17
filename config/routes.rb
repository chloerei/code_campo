CodeCampo::Application.routes.draw do
  root :to => 'homepage#index'

  get 'signup' => 'users#new', :as => :signup
  resources :users, :only => [:create]
end
