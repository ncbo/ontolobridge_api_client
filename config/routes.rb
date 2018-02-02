Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => 'ontolobridge#index'

  match '/term_status' => 'ontolobridge#term_status', via: [:post]
  match '/request_term' => 'ontolobridge#request_term', via: [:post]
end
