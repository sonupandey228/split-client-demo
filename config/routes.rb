Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/toggles' => 'toggle#index'
  get '/toggles/:toggle_name' => 'toggle#check_toggle'
end
