Rails.application.routes.draw do
  post '/add_transaction', to: 'transactions#create'
end
