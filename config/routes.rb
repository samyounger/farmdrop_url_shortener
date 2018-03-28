Rails.application.routes.draw do
  root 'url_strings#index'

  get '/:id', to: 'url_strings#show'
  post '/', to: 'url_strings#create'
end
