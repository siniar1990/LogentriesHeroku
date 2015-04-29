WexfordBus::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to=>"authentication#sign_in"

  get "home" =>"home#index"

  get "sign_in" => "authentication#sign_in"
  get "signed_out" => "authentication#signed_out"
  get "my_reservations" => "authentication#my_reservations"
  get "reservation_canceled" => "authentication#reservation_canceled"


  get "create_commuter" => "operator#create_commuter"
  get "delete_commuter" => "operator#delete_commuter"
  get "show_commuter" => "operator#show_commuter"
  get "suspend_commuter" => "operator#suspend_commuter"
  get "activate_commuter" => "operator#activate_commuter"
  get "warn_commuter" => "operator#warn_commuter"
  get "all_users" => "operator#all_users"
  get "custom_email" => "operator#custom_email"



  get "past" => "operator#past"
  get "today" => "operator#today"
  get "future" => "operator#future"
  get "display_reservations" => "operator"

  get "reservations" => "operator#reservations"




  get "create_reservation" => "reservation#create_reservation"
  get "find_reservation" => "reservation#find_reservation"
  get "cancel_reservation" => "reservation#cancel_reservation"

  get "bus_connections" => "home#bus_connections"
  get "available_times" => "home#available_times"
  get "show_seats" => "home#show_seats"
  get "change_time" => "home#change_time"


  post "sign_in" => "authentication#login"
  post "create_commuter" =>"operator#register"
  post "delete_commuter" => "operator#delete"
  post "show_commuter" => "operator#show"
  post "suspend_commuter" => "operator#suspend"
  post "activate_commuter" => "operator#activate"
  post "warn_commuter" => "operator#warn"



  post "create_reservation" => "reservation#create"
  post "find_reservation" => "reservation#find"
  post "cancel_reservation" => "authentication#cancel"

  post "bus_connections" => "home#available_times"
  post "available_times" => "home#available_times"
  post "show_seats" => "home#show_seats"
  post "change_time" => "home#change_time"

end
