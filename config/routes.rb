Timetien::Application.routes.draw do
  resources :project_users

  devise_for :users, :path_names => {:sign_up => "register"}, :controllers => {:registrations => 'registrations'}

  resources :tasks
  resources :tags
  resources :analyze_tasks
  resources :projects
  resources :authentications, :only => [:index, :authenticate, :destroy]

  match 'query_tasks' => 'analyze_tasks#query_tasks', :as => 'query_tasks'
  match 'start_task' => 'tasks#start_task', :as => 'start_task'
  match 'stop_task/:id' => 'tasks#stop_task', :as => 'stop_task'
  match 'delete_task/:id', :to => 'tasks#destroy', :as => 'delete_task'
  match 'new2', :to => 'tasks#new2', :as => 'new2_task'
  match 'delete_analyze_task', :to => 'analyze_tasks#destroy_task', :as => 'delete_analyze_task'
  match 'analyze_project_tasks', :to => 'analyze_tasks#analyze_project_tasks', :as => 'analyze_project_tasks'
  match 'analyze_user_tasks', :to => 'analyze_tasks#analyze_user_tasks', :as => 'analyze_user_tasks'
  match 'get_project_tags', :to => 'analyze_tasks#get_project_tags', :as => 'get_project_tags'
  match 'accept_invite/:id', :to => 'projects#accept_invite', :as => 'accept_invite'
  match '/auth/:service/callback' => 'authentications#authenticate'
  match 'get_tags', :to => 'projects#get_tags', :as => 'get_tags'
  match 'get_project_users', :to => 'projects#get_project_users', :as => 'get_project_users'

  root :to => 'tasks#manage'
  match '/user' => "tasks#manage", :as => :user_root

  match 'about', :to => 'pages#about', :as => :about
  match 'privacy', :to => 'pages#privacy', :as => :privacy

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
