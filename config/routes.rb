Rails.application.routes.draw do
  post '/transaction', to: 'transactions#create'
end
