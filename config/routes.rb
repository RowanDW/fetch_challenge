Rails.application.routes.draw do
  post '/add_transaction', to: 'transactions#create'
  get '/points_balance', to: 'points#balance'
end
