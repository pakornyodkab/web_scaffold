Rails.application.routes.draw do
  resources :users
  get 'user/delview/:id',to:"users#delview", as: 'user_delview'
  get 'user/create_fast/:name/:email' ,to:"users#create_fast" ,as: 'user_create_fast'
  get'/main' ,to:"users#main"
  post'/main' ,to:"users#findbyemail"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
