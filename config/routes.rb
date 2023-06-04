Rails.application.routes.draw do
  get '/', to: 'mainpage#index'
  
  root 'mainpage#index'

  devise_for :users, controllers: { registrations: "users/registrations" }
  
  resources :clinics do
    resources :departments
  end
  
  resources :departments do
    resources :doctors
  end
  
  resources :departments do
    resources :patient_cards
  end
  
  resources :patient_cards

  resources :patients
  
  resources :doctors do
    resources :specialties
  end
  
  resources :specialties
end