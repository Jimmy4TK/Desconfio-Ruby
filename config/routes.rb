Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  post '/users/:id/change_password', to: 'users#change_password'

  resources :users, only:[:create]
end
