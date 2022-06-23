Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  put '/users/:id/change_password', to: 'users#change_password'
  resources :users, only:[:create]

  get '/games/incomplete', to: 'games#incomplete'
  put '/games/:id/assign_player', to:'games#assign_player'
  resources :games, only:[:show,:create]
end
