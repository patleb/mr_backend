Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'main#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
