ActionController::Routing::Routes.draw do |map|
  map.resources :immeubles

  map.resources :factures
  
  map.resources :depenses

  
  map.resources :prereservations
  
  map.resources :bails

  map.resources :clients
  
  map.resources :appartements
  
  map.resources :reservations
  
  map.resources :paiements
  
  map.resources :proprietaires

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
  
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
 map.resource :prereservation, :controller => 'prereservation'  
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
   map.connect '', :controller => "reservations"
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.outils  'reservations/choixBilan/2', :controller => 'reservations', :action => 'choixBilan',:id=>2
end
