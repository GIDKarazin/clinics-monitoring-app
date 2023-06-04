Rails.application.routes.draw do
  resources :clinics
  
  resources :departments

  resources :doctors

  resources :patients

  resources :patient_cards

  resources :specialties
end