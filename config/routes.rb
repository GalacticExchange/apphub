Rails.application.routes.draw do
  #devise_for :users

  if Rails.env.development?
    resources :store_application
  end
  # optimacms devise

  root to: "home#index"

  get 'tmp', to: 'containers#tmp'
  get 'faq', to: 'home#faq'
  get 'api', to: 'api#index'
  get 'api/store_applications/get', to: 'api#get_store_application'
  put 'api/store_applications/new', to: 'api#create_store_application'
  get 'api/store_applications/list', to: 'api#list_store_application'
  put 'api/store_applications/update', to: 'api#update_store_application'
  get '/api/app_meta/:github_user/:url_path/:file_type(.:format)', to: 'api#app_meta', url_path: /.*?/,
      file_type: /(metadata)/, format: //
  delete 'api/store_applications/destroy', to: 'api#delete_store_application'
  get 'api/store_applications/random', to: 'api#random_store_application'
  get 'api/search', to: 'api#search'

  get 'search', to: 'search#index'
  post 'search', to: 'search#index'

  get 'newsitemap.xml', to: 'home#site_map', :defaults => { :format => 'xml' }, as: 'sitemap_path'
  get 'robots.txt', to: 'home#robots', defaults: { format: 'txt' }, as: 'robots_path'

  get 'google8edb67cb3b980603.html', to: 'home#google_verif'
  get ':github_user/*url_path(.:format)', to: 'store_application#render_store_application', as: 'my_store_application_path', url_path: /.*?/, format: //



  # devise_for :cms_admin_users, Optimacms::Devise.config
  # mount Optimacms::Engine => "/", :as => "cms"

  # for names

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  #root 'home#index'

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

  #



end
