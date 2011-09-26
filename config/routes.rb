LaramieNew::Application.routes.draw do
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
  
# Accounts and article comments have been disabled in this version of the NLRA site
=begin
  resource :account do
    member do
      get 'login'
      post 'login'
      get 'logout'
      get 'change_password'
      get 'delete'
    end
    
    resources :comments, :except => [:new, :create]
    
  end
=end  
 
   scope :module => :admin, :as => "admin" do
     constraints :subdomain => "admin" do
     resources :articles do
       post 'preview', :on => :collection
       # resources :comments
     end
     resources :users do
       collection do
         # get 'postal_list'
         match 'bulk_emails', :via => [:get, :post]
         post 'delete_multiple'
       end
     end
     resources :events
     match 'listhost_mail' => 'main#listhost_mail'
     match 'preview_message' => 'main#preview_message'
     match 'send_listhost_message' => 'main#send_listhost_message'
     root :to => 'main#index'
   end
 end
 
 class SubdomainCheck
   
   def matches?(request)
     request.subdomain != 'admin'
   end
   
 end
 
constraints SubdomainCheck.new do # these routes (those of the main site) only function if the subdomain is NOT 'admin'


  match 'calendar/:year/:month/:day' => 'calendar#day', :as => :calendar, :constraints => { :year => /20\d{2}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
  
  match 'calendar/(:year/:month)' => 'calendar#index', :as => :calendar, :constraints => { :year => /20\d{2}/, :month => /\d{1,2}/}

  resources :articles, :only => [:show, :index] do
    # resources :comments
  end
  
  resources :events do
    get 'download', :on => :member
  end

  
  match 'subscribers/:action(/:id(.:format))' => "subscribers"
  
  match 'get_involved' => 'main#get_involved'
  match 'who_we_are' => 'main#who_we_are'
  match 'documents' => 'main#documents'
  match 'views' => 'main#views'
  match 'contact_us' => 'main#contact'
  match 'contact' => 'main#contact'
  match 'faq' => 'main#faq'
  match 'donate' => 'main#donate'
  match 'subscribers' => 'subscribers#assistance'
  match 'subscribe' => 'subscribers#assistance'
  match 'about' => 'main#about'
  match 'documents' => 'main#documents'
  match 'legal' => 'main#legal'
  match 'action' => 'main#action'
  match 'subscribers/create' => 'subscribers#create'
  match 'main/info_link' => 'main#info_link'
  match 'slideshow' => 'main#slideshow'
  match 'petitions' => 'main#petitions'

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
  # root :to => "welcome#index"
  
  root :to => 'main#index'
  
end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
