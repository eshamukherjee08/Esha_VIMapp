EshaVIMapp::Application.routes.draw do

  resources :candidates do
    collection do
      get "mark_candidate_star"
      get "find_category"
      get "find_star_category"
      get "delete_candidate", :to => "candidates#destroy"
      get "starred_list"
    end
    
    member do
      get "download_resume"
    end
  end
     

  get "home/index"
  get "home/search", :to => "home#search", :as => "search"
  get "find_search_data", :to => "home#find_data", :as => "find_search_data"
  
  devise_for :admins, :controllers => { :invitations => 'admins/invitations', :sessions => 'admins/sessions', :passwords => 'passwords' }

  resources :passwords
  resources :batches
  resources :walkins, :only => [:index]
  
  get "change_map_location", :to => "events#change_map", :as => "change_map_location"
  get "google_map/index"
  get "map_location", :to => "walkins#change_map", :as => "map_location"
            
  resources :events do
    collection do 
      get "past"
    end
    
    member do
      get "wait_list"
    end
    
    resources :candidates do
      get "confirmation/:perishable_token", :to => "candidates#confirmation", :as => "confirmation"
      member do
        get "admitcard"
        get "cancel"
      end
    end
    
    resources :events_candidates do
      collection do
        post "mark_attended"
      end
    end
  end
  
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'walkins#index'
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
