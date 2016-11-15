Rails.application.routes.draw do


  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
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

  get 'verify_phone/new'=> 'spree/verify_phone#new'
  post 'verify_phone/send_otp' => 'spree/verify_phone#send_otp'
  post '/verify_phone/verify_phone/verify_otp' => 'spree/verify_phone#verify_otp'
  get 'verify_phone/enter_otp' => 'spree/verify_phone#enter_otp'

  get '/invite' => 'spree/user_invites#new'
  post '/invite/create' => 'spree/user_invites#create'

  get '/wallet' => 'spree/wallet#show'
  post '/wallet/credit_money' => 'spree/wallet#credit_money'

    resources :products do
      post 'favorite_a_product'
      post 'unfavorite_a_product'
    end

    get "/sale" => "home#sale"

    get '/admin/sellers' => 'spree/admin/sellers#index', as: :admin_sellers
    get '/admin/sellers/new' => 'spree/admin/sellers#new', as: :new_admin_seller
    post '/admin/sellers/create' => 'spree/admin/sellers#create', as: :admin_seller
    get '/admin/sellers/:id/edit' => 'spree/admin/sellers#edit', as: :edit_admin_seller
    post '/admin/sellers/update' => 'spree/admin/sellers#update', as: :update_admin_seller

    get '/admin/store_locations' => 'spree/admin/store_location#index'
    get '/admin/store_locations/new' => 'spree/admin/store_location#new'
    post '/admin/store_locations/create' => 'spree/admin/store_location#create'
    get '/admin/store_locations/:id/edit' => 'spree/admin/store_location#edit'
    post '/admin/store_locations/update' => 'spree/admin/store_location#update'


end
