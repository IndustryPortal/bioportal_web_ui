Rails.application.routes.draw do

  root to: 'home#index'

  resources :notes, constraints: { id: /.+/ }

  resources :ontolobridge do
    post :save_new_term_instructions, on: :collection
  end

  resources :projects, constraints: { id: /[^\/]+/ }

  resources :users, path: :accounts, constraints: { id: /[\d\w\.\-\%\+ ]+/ }

  resources :reviews

  get '/mappings/loader' , to: 'mappings#loader'
  #post '/mappings/loader', to: 'mappings#loader_process'
  post '/mappings/loader_process', to: 'mappings#loader_process'
  get 'mappings/count/:id', to: 'mappings#count', constraints: { id: /.+/ }
  get 'mappings/show_mappings', to: 'mappings#show_mappings'
  get 'mappings/new', to: 'mappings#new'
  get 'mappings/:id', to: 'mappings#show', constraints: { id: /.+/ }
  post 'mappings/:id', to: 'mappings#update', constraints: { id: /.+/ }
  delete 'mappings/:id', to: 'mappings#destroy', constraints: { id: /.+/ }
  resources :mappings

  resources :margin_notes

  resources :concepts

  get 'ontologies/:ontology_id/concepts', to: 'concepts#show_concept'
  resources :ontologies do
    resources :submissions
    get 'instances/:instance_id', to: 'instances#show', constraints: { instance_id: /[^\/?]+/ }
    get 'schemes/show_scheme', to: 'schemes#show'
  end

  resources :login

  resources :admin, only: [:index]

  namespace :admin do
    resources :licenses, only: [:index, :create, :new]
  end

  resources :subscriptions

  resources :recommender

  resources :annotator

  resources :annotatorplus

  resources :ncbo_annotatorplus

  resources :virtual_appliance

  get '' => 'home#index'

  # Top-level pages
  match '/feedback', to: 'home#feedback', via: [:get, :post]
  get '/account' => 'home#account'
  get '/help' => 'home#help'
  get '/about' => 'home#about'
  get '/site_config' => 'home#site_config'
  get '/validate_ontology_file' => 'home#validate_ontology_file_show'
  match '/validate_ontology_file' => 'home#validate_ontology_file', via: [:get, :post]
  get '/layout_partial/:partial' => 'home#render_layout_partial'
  match '/visits', to: 'visits#index', via: :get

  # Error pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Analytics
  match 'analytics', to: 'analytics#track', via: [:post] 
  
  # Robots.txt
  get '/robots.txt' => 'robots#index'

  # Ontologies
  get '/ontologies/view/edit/:id' => 'ontologies#edit_view', :constraints => { id: /[^\/?]+/ }
  get '/ontologies/view/new/:id' => 'ontologies#new_view'
  
  get '/ontologies/virtual/:ontology' => 'ontologies#virtual', :as => :ontology_virtual
  get '/ontologies/success/:id' => 'ontologies#submit_success'
  match '/ontologies/:acronym' => 'ontologies#update', via: [:get, :post]
  match '/ontologies/:acronym/submissions/:id' => 'submissions#update', via: [:get, :post]
  get '/ontologies/:ontology_id/submissions/new' => 'submissions#new', :ontology_id => /.+/
  match '/ontologies/:ontology_id/submissions' => 'submissions#create', :ontology_id => /.+/, via: [:get, :post]
  get '/ontologies/:acronym/classes/:purl_conceptid', to: 'ontologies#show', constraints: { purl_conceptid: /[^\/]+/ }
  get '/ontologies/:acronym/: f', to: 'ontologies#show', constraints: { purl_conceptid: /[^\/]+/ }
  match '/ontologies/:acronym/submissions/:id/edit_metadata' => 'submissions#edit_metadata', via: [:get, :post]

  # Analytics
  get '/analytics/:action' => 'analytics#(?-mix:search_result_clicked|user_intention_surveys)'

  # Notes
  get 'ontologies/:ontology/notes/:noteid', to: 'notes#virtual_show', as: :note_virtual, noteid: /.+/

  # Ajax
  get '/ajax/' => 'ajax_proxy#get', :as => :ajax
  get '/ajax_concepts/:ontology/' => 'concepts#show', :constraints => { id: /[^\/?]+/ }
  get '/ajax/class_details' => 'concepts#details'
  get '/ajax/mappings/get_concept_table' => 'mappings#get_concept_table'
  get '/ajax/json_ontology' => 'ajax_proxy#json_ontology'
  get '/ajax/json_class' => 'ajax_proxy#json_class'
  get '/ajax/jsonp' => 'ajax_proxy#jsonp'
  get '/ajax/loading_spinner' => 'ajax_proxy#loading_spinner'
  get '/ajax/notes/delete' => 'notes#destroy'
  get '/ajax/notes/concept_list' => 'notes#show_concept_list'
  get '/ajax/classes/label' => 'concepts#show_label'
  get '/ajax/classes/definition' => 'concepts#show_definition'
  get '/ajax/classes/treeview' => 'concepts#show_tree'
  get '/ajax/properties/tree' => 'concepts#property_tree'
  get 'ajax/:ontology_id/schemes/:scheme_id/show_label', to: "schemes#show_label", constraints: { scheme_id: /[^\/?]+/ }
  get '/ajax/biomixer' => 'concepts#biomixer'
  get '/ajax/fair_score/html' => 'fair_score#details_html'
  get '/ajax/fair_score/json' => 'fair_score#details_json'
  get '/ajax/:ontology/instances' => 'instances#index_by_ontology'
  get '/ajax/:ontology/classes/:conceptid/instances' => 'instances#index_by_class', :constraints => { conceptid: /[^\/?]+/ }

  # User
  get '/logout' => 'login#destroy', :as => :logout
  get '/lost_pass' => 'login#lost_password'
  get '/reset_password' => 'login#reset_password'
  post '/accounts/:id/custom_ontologies' => 'users#custom_ontologies', :as => :custom_ontologies
  get '/login_as/:login_as' => 'login#login_as' , constraints: { login_as:  /[\d\w\.\-\%\+ ]+/ }
  post '/login/send_pass', to: 'login#send_pass'

  # History
  get '/tab/remove/:ontology' => 'history#remove', :as => :remove_tab
  get '/tab/update/:ontology/:concept' => 'history#update', :as => :update_tab

  get 'jambalaya/:ontology/:id' => 'visual#jam', :as => :jam

  # Admin
  match '/admin/clearcache' => 'admin#clearcache', via: [:post]
  match '/admin/resetcache' => 'admin#resetcache', via: [:post]
  match '/admin/clear_goo_cache' => 'admin#clear_goo_cache', via: [:post]
  match '/admin/clear_http_cache' => 'admin#clear_http_cache', via: [:post]
  match '/admin/ontologies_report' => 'admin#ontologies_report', via: [:get]
  match '/admin/refresh_ontologies_report' => 'admin#refresh_ontologies_report', via: [:post]
  match '/admin/ontologies' => 'admin#delete_ontologies', via: [:delete]
  match '/admin/ontologies' => 'admin#process_ontologies', via: [:put]
  match '/admin/ontologies/:acronym/submissions/:id' => 'admin#delete_submission', via: [:delete]
  match '/admin/ontologies/:acronym/submissions' => 'admin#submissions', via: [:get]
  match '/admin/ontologies/:acronym/log' => 'admin#parse_log', via: [:get]
  match '/admin/update_info' => 'admin#update_info', via: [:get]
  match '/admin/update_check_enabled' => 'admin#update_check_enabled', via: [:get]
  match '/admin/users' => 'admin#users', via: [:get]


  # Ontolobridge
  # post '/ontolobridge/:save_new_term_instructions' => 'ontolobridge#save_new_term_instructions'

  ###########################################################################################################
  # Install the default route as the lowest priority.
  get '/:controller(/:action(/:id))'
  ###########################################################################################################

  #####
  ## OLD ROUTES
  ## All of these should redirect to new addresses in the controller method or using the redirect controller
  #####

  # Redirects from old URL locations
  get '/annotate' => 'redirect#index', :url => '/annotator'
  get '/visconcepts/:ontology/' => 'redirect#index', :url => '/visualize/'
  get '/ajax/terms/label' => 'redirect#index', :url => '/ajax/classes/label'
  get '/ajax/terms/definition' => 'redirect#index', :url => '/ajax/classes/definition'
  get '/ajax/terms/treeview' => 'redirect#index', :url => '/ajax/classes/treeview'
  get '/ajax/term_details/:ontology' => 'redirect#index', :url => '/ajax/class_details'
  get '/ajax/json_term' => 'redirect#index', :url => '/ajax/json_class'

  # Visualize
  get '/visualize/:ontology' => 'ontologies#visualize', :as => :visualize, :constraints => { ontology: /[^\/?]+/ }
  get '/visualize/:ontology/:conceptid' => 'ontologies#visualize', :as => :uri, :constraints => { ontology: /[^\/?]+/, conceptid: /[^\/?]+/ }
  get '/visualize' => 'ontologies#visualize', :as => :visualize_concept, :constraints => { ontology: /[^\/?]+/, id: /[^\/?]+/, ontologyid: /[^\/?]+/, conceptid: /[^\/?]+/ }

  get '/exhibit/:ontology/:id' => 'concepts#exhibit'

  #Souslesens page
  get '/souslesens', to:'souslesens#index'

  #Team page
  get '/team', to:'team#index'

end
