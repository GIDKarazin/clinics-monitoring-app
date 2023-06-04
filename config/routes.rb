Rails.application.routes.draw do
  get '/', to: 'mainpage#index'

  get 'clinics/search', to: 'clinics#search', as: 'clinics_search'
  get 'clinics/:id/searchshow', to: 'clinics#searchshow', as: 'clinics_search_show'
  get 'departments/search', to: 'departments#search', as: 'departments_search'
  get 'doctors/search', to: 'doctors#search', as: 'doctors_search'
  get 'specialties/search', to: 'specialties#search', as: 'specialties_search'
  get 'patient_cards/search', to: 'patient_cards#search', as: 'patient_cards_search'
  get 'patients/search', to: 'patients#search', as: 'patients_search'
  
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