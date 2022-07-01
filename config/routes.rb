Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  put '/users/:id/change_password', to: 'users#change_password'
  resources :users, only:[:create]

  get '/games/incomplete', to: 'games#incomplete'
  get '/games/:id/desconfio', to:'games#desconfio'
  put '/games/:id/assign_player', to:'games#assign_player'
  post '/games/:id/drop_card', to:'games#drop_card'

  resources :games, only:[:show,:create]
end
