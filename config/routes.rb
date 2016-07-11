Cbcl4::Application.routes.draw do
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
 
  # namespace :api do
  #   resources :answer_reports
  # end
 
  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  get 'subscriptions/all', :to => 'subscriptions#all', :as => 'subscriptions_all'

  get '/score_scales/order', :to => 'score_scales#order', :as => 'order'

  get 'users/list', :to => 'users#list', :as => 'user_list'
  # get 'login', :to => 'login#login', :as => 'login'

  # Install the default route as the lowest priority.
  # map.resources :skemas
  # resource  :home
  # resources :logins
  resources :answer_charts, :only => [:show]
  resources :answer_reports
  resources :centers
  resources :code_books
  resources :export_files
  resources :exports
  resources :journal_entries, :only => [:show, :edit, :update]
  resources :journal_notes
  resources :journal_stats
  resources :journals
  resources :letters
  resources :login_letters
  resources :follow_up_letters
  resources :login_users
  resources :nationalities
  resources :reminders
  resources :roles
  resources :score_exports
  resources :score_items, :except => [:create]
  resources :score_refs, :except => [:create]
  resources :score_reports
  resources :score_scales
  resources :scores
  resources :sessions
  resources :subscriptions
  resources :survey_answers, :except => [:create]
  resources :survey_builders
  resources :surveys
  resources :teams, :except => [:new]
  resources :users, :except => [:new]
  resources :variables
  
  namespace(:active_rbac) do |active_rbac|
    resources :roles
  end

  # if Rails.env.production?
    get '404', :to => 'application#page_not_found'
    get '422', :to => 'application#server_error'
    get '500', :to => 'application#server_error'
  # end

  # map the admin stuff into '/admin/'
  # get '/user/:action/(/:id)', :controller => 'active_rbac/user'
  get '/admin/groups/:action/(/:id)', :to => 'active_rbac/groups'
  get '/admin/roles/:action/(/:id)', :to => 'active_rbac/roles'
  # get '/admin/static_permission/:action/(/:id)', :controller => 'active_rbac/static_permission'
  
  # map the login and registration controller somewhere prettier
  # get '/login', :to => 'login#index', :as => 'login'
  # get '/logout', :to => 'login#logout', :as => 'logout'
  # get '/shadow_login', :to => 'login#shadow_login', :as => 'shadow_login'
  get '/shadow_logout', :to => 'login#shadow_logout', :as => 'shadow_logout'
  get '/login/shadow_login/(/:id)', :to => 'login#shadow_login', :as => 'shadow_login'
  # get '/login/shadow_logout', :to => 'login#shadow_logout', :as => 'shadow_logout'

  match "/logout" => "login#logout", :as => "logout", :via => [:get, :post]
  match "login" => "login#login", :as => "login", :via => [:get, :post]
  # get "signup" => "users#new", :as => "signup"
  get "/users/delete/(/:id)" => "users#delete", :as => "delete_user"
  # get "main" => "main#index", :as => "index"
  # user
  get 'change_password/(/:id)', :to => 'user#change_password', :as => 'change_password'
  get 'generate_password/(/:id)', :to => 'password#new', :as => 'generate_password'

  get '/survey_prints/print/(/:id)', :to => 'survey_prints#print', :as => 'print_survey'

  post '/journal_entries/show/(/:id)', :to => 'journal_entries#show', :as => 'show_survey'
  # center
  post 'centers/activate', :to => 'centers#activate', :as => 'activate_center'
  get '/centers/delete/(/:id)', :to => 'centers#delete', :as => 'delete_center'
  match '/centers/live_search/(/:id)', :to => 'centers#live_search', :as => 'center_search', :via => [:get, :post]
  get 'subscriptions/new/(/:id)', :to => 'subscriptions#new', :as => 'new_subscription_in_group'
  get 'subscriptions/new_period/(/:id)', :to => 'centers#new_subscription_period', :as => 'subscriptions_new_period'
  get 'subscriptions/undo_new_period/(/:id)', :to => 'centers#undo_new_subscription_period', :as => 'subscriptions_undo_last_period'
  get 'subscriptions/show/:id/:start/:stop', :to => 'subscriptions#show', :as => 'show_subscription_in_period'

  get 'users/center/(/:id)/partial=:partial', :to => 'users#center', :as => 'users_center'
  get 'users/new/(/:id)', :to => 'users#new', :as => 'new_user'
  # get 'users/(/:page)?partial=true', :to => 'users#indexjs', :as => 'users_indexjs'

  match 'centers/pay_subscriptions/(/:id)', :to => 'centers#pay_subscriptions', :as => 'pay_subscriptions', :via => [:get, :post]
  match 'centers/undo_pay_subscriptions/(/:id)', :to => 'centers#undo_pay_subscriptions', :as => 'undo_pay_subscriptions', :via => [:get, :post]
  get 'centers/pay_periods/(/:id)', :controller => 'centers',                       :action => 'pay_periods'
  get 'centers/merge_periods/(/:id)', :controller => 'centers',                   :action => 'merge_periods'
  
  get '/teams/new/(/:id)', :to => 'teams#new', :as => 'new_team'
  get '/teams/delete/(/:id)', :to => 'teams#delete', :as => 'delete_team'
  get '/teams/center/(/:id)', :to => 'teams#center' #, :as => 'teams_in_center'
  get '/journals/center/(/:id)', :to => 'journals#center', :as => 'journals_for_center'
  get '/journals/select/(/:id)', :to => 'journals#select', :as => 'select_journals'
  get '/journals/move/(/:id)', :to => 'journals#move', :as => 'move_journals'

  get '/journals/move_journal_to_group/(:id)', :to => 'journals#select_group', :as => 'move_journal_to_group'
  put '/journals/move_journal/(:id)', :to => 'journals#move', :as => 'move_journal'
  match 'journals/search/(/:search_journals)', :to => 'journals#search', :as => 'journal_search', :via => [:get, :post]
  # get 'journals/new/(/:id)', :to => 'journals#new', :as => 'new_journal'
  get '/journals/delete/(/:id)', :to => 'journals#delete', :as => 'delete_journal'
  match '/journals/destroy/(/:id)', :to => 'journals#destroy', :as => 'destroy_journal', :via => [:delete]
  match '/journals/add_survey/(/:id)', :to => 'journals#add_survey', :as => 'journal_add_survey', :via => [:get, :post]
  match '/journals/remove_survey/(/:id)', :to => 'journals#remove_survey', :as => 'journal_remove_survey', :via => [:get, :post]

  # journal entries
  get 'journal_entries/show_answer/(/:id)', :to => 'journal_entries#show_answer', :as => 'entry_show_answer'
  post 'journal_entries/update_notes/(/:id)', :to => 'journal_entries#update_notes', :as => 'update_notes', :only => :post
  post 'journal_entries/remove/(/:id)', :to => 'journal_entries#remove', :as => 'entry_remove', :only => :post
  post 'journal_entries/remove_answer/(/:id)', :to => 'journal_entries#remove_answer', :as => 'entry_remove_answer', :only => :post
  get 'journal_entries/edit_chain/(/:id)', :to => 'journal_entries#edit_chain', :as => 'edit_journal_entry_chain'
  post 'journal_entries/update_chain/(/:id)', :to => 'journal_entries#update_chain', :as => 'update_journal_entry_chain', :only => :post
  get 'login_letters/show_login/(/:id)', :to => 'login_letters#show_login', :as => 'show_login_letter'
  get 'login_letters/show_logins/(/:id)', :to => 'login_letters#show_logins', :as => 'print_letters'
  # get 'letters/new/(/:id)', :to => 'letters#new', :as => 'new_letter'
  
  # get 'journal_entries/destroy_login/(/:id)', :to => 'journal_entries#destroy_login', :as => 'destroy_login', :only => :post
  
  # get 'users/list', :to => 'users#list', :as => 'user_list'
  get '/users/live_search/(/:name)', :to => 'users#live_search', :as => 'user_search'
  # get 'users/new/(/:id)', :to => 'users#new', :as => 'new_user'
  # get '/users/delete/(/:id)', :to => 'users#delete', :as => 'delete_user'
  get '/centers/new_team/(/:id)', :to => 'centers#new_team', :as => 'new_team_in_center'

  get 'upgrade', :to => 'start#upgrade', :as => 'upgrade_browser'
  # get '/start/(/:api_key)/(/:token)', :to => 'login#start', :as => 'api_login_survey_start'
  get '/logout/(:api_key)/(/:token)', :to => 'api_login#logout', :as => 'api_logout'
  get 'api/continue/(:api_key)/(:token)', :to => 'api_start#continue', :as => 'api_survey_continue'
  
  get 'start/(:api_key)/(:token)', :to => 'start#start', :as => 'survey_start'
  get 'continue/(:api_key)/(:token)', :to => 'start#continue', :as => 'survey_continue'
  get 'next/:id/(:api_key)/(:token)', :to => 'start#next', :as => 'survey_next'      # :id is login_user
  get 'finish/(/:id)/(:api_key)/(:token)', :to => 'start#finish', :as => 'survey_finish'      # :id is login_user

  # get 'finish/(/:id)', :to => 'start#finish', :as => 'survey_finish'      # :id is login_user
  get 'surveys/show_fast/(/:id)', :to => 'surveys#show_fast', :as => 'survey_show_fast' # :id is entry
  get 'surveys/show_only/(/:id)', :to => 'surveys#show_only', :as => 'survey_show_only' # :id is entry
  # get 'surveys/show_only_fast/(/:id)', :to => 'surveys#show_only_fast', :as => 'survey_show_only_fast' # :id is entry
  match 'survey_answers/save_draft/(/:id)/(/:journal_id)', :to => 'survey_answers#save_draft', :as => 'survey_save_draft', :via => :post # :id is entry
  post 'survey_answers/create/(/:id)/(/:journal_id)', :to => 'survey_answers#create', :as => 'survey_answer_create'
  get 'survey_answers/done/(/:id)', :to => 'survey_answers#done', :as => 'survey_answer_done' # :id is entry
  get 'survey_answers/edit_date/(/:id)', :to => 'survey_answers#edit_date', :as => 'edit_date_survey_answers'
  post 'survey_answers/update_date/(/:id)', :to => 'survey_answers#update_date', :as => 'update_date_survey_answers'

  post 'survey_answers/json_draft_data/(/:id)', :to => 'survey_answers#json_draft_data', :as => 'json_draft_data', :format => 'json'
  post 'survey_answers/json_dynamic_data/(/:id)', :to => 'survey_answers#json_dynamic_data', :as => 'json_dynamic_data', :format => 'json'

  # subscriptions
  # get 'subscriptions/new/(/:id)', :to => 'subscriptions#new', :as => 'new_subscription' # center id
  get 'subscriptions/reset/(/:id)', :to => 'subscriptions#reset', :as => 'subscription_reset'
  get 'subscriptions/reset_all/(/:id)', :to => 'subscriptions#reset_all', :as => 'subscription_reset_all'
  get 'subscriptions/activate/(/:id)', :to => 'subscriptions#activate', :as => 'subscription_activate'
  get 'subscriptions/deactivate/(/:id)', :to => 'subscriptions#deactivate', :as => 'subscription_deactivate'
  get 'subscriptions/set_subscription_note/(/:id)', :to => 'subscriptions#set_subscription_note', :as => 'set_subscription_note'
  
  match 'exports/download/(/:id)', :to => 'exports#download', :as => 'csv_download', :via => [:get, :post]
  get 'exports/set_age_range/(/:id)', :to => 'exports#set_age_range', :as => 'set_age_range'
  get 'exports/filter/(/:id)', :to => 'exports#filter', :as => 'export_filter'
  get 'exports/generating_export/(/:id)', :to => 'exports#generating_export', :as => 'generating'

  # wide table export
  match 'wide_exports/download/(/:id)', :to => 'wide_exports#download', :as => 'wide_csv_download', :via => [:get, :post]
  get 'wide_exports/set_age_range/(/:id)', :to => 'wide_exports#set_age_range', :as => 'wide_set_age_range'
  get 'wide_exports/filter/(/:id)', :to => 'wide_exports#filter', :as => 'wide_export_filter'
  get 'wide_exports/generating_export/(/:id)', :to => 'wide_exports#generating_export', :as => 'wide_generating'

  match 'score_exports/download/(/:id)', :to => 'score_exports#download', :as => 'csv_score_rapport_download', :via => [:get, :post]
  # get 'exports/download/(/:id)', :to => 'exports#download', :as => 'csv_download'

  # get 'reminders/download/(/:id)', :to => 'reminders#download', :as => 'download'
  match 'reminders/show/:id/(:state)/(:follow_up)(.:format)', :to => 'reminders#show', :as => 'answer_status', :via => [:get, :post]
  match 'reminders/filter/:id/(:state)/(:follow_up)', :to => 'reminders#filter', :as => 'filter_status', :via => [:get, :post]
  match 'reminders/download/(:id).:format', :to => 'reminders#download', :as => 'csv_entry_status_download', :format => 'csv', :via => [:get, :post]
  match 'reminders/generate_file/(:id)/(:state)/(:follow_up)', :to => 'reminders#generate_file', :as => 'generate_file', :via => [:get, :post]
  get 'export_files/show/(/:id)', :to => 'export_files#show', :as => 'export_login'
  get 'export_files/download/(/:id).:format', :to => 'export_files#download', :as => 'file_download', :format => 'csv'
  match 'export_logins/download/:id.:format', :to => 'export_logins#download', :as => 'export_logins', :format => 'csv', :via => [:get, :post]

  # get 'faqs/new/(/:id)', :to => 'faqs#new', :as => 'new_faq'
  get 'faqs/answer/(/:id)', :to => 'faqs#answer', :as => 'faq_answer'
  get 'faq_sections/order_questions/(/:id)', :to => 'faq_sections#order_questions', :as => 'faq_order_questions'
  get 'faq_sections/done_order_questions/(/:id)', :to => 'faq_sections#done_order_questions', :as => 'faq_done_order_questions'
  get 'faq_sections/sort_questions/(/:id)', :to => 'faq_sections#sort_questions', :as => 'faq_sort_questions'
  get 'faq_sections/order/(/:id)', :to => 'faq_sections#order', :as => 'faq_order'
  get 'faq_sections/sort/(/:id)', :to => 'faq_sections#sort', :as => 'faq_sort'
  get 'faq_sections/done_order/(/:id)', :to => 'faq_sections#done_order', :as => 'faq_done_order'
  
  # get 'scores/edit/(/:id)', :to => 'scores#edit', :as => 'edit_score'
  match 'score_items/create/(/:id)', :to => 'score_items#create', :as => 'create_score_item', :via => [:get, :post]
  match 'score_refs/create/(/:id)', :to => 'score_refs#create', :as => 'create_score_ref', :via => [:get, :post]

  get 'score_scales/edit_survey', :to => 'scores#edit_survey', :as => 'scores_edit_survey'

  get 'score_items/cancel', :to => 'score_items#cancel', :as => 'cancel_score_item'
  # get 'score_items/new/(/:id)', :to => 'score_items#new', :as => 'new_score_item'
  # get 'score_refs/new/(/:id)', :to => 'score_refs#new', :as => 'new_score_ref'
  get 'score_refs/cancel', :to => 'score_refs#cancel', :as => 'cancel_score_ref'

  get 'score_scales/order_scores', :to => 'score_scales#order_scores', :as => 'scores_order'
  get 'score_scales/sort_scores', :to => 'score_scales#sort_scores', :as => 'scores_sort'
  get 'score_scales/done_order_scores', :to => 'score_scales#done_order_scores', :as => 'scores_done_order'
  get 'score_scales/order', :to => 'score_scales#order', :as => 'scales_order'
  get 'score_scales/sort', :to => 'score_scales#sort', :as => 'scales_sort'
  get 'score_scales/done_order', :to => 'score_scales#done_order', :as => 'scales_done_order'
  get 'score_scales/scale_surveys', :to => 'score_scales#scale_surveys', :as => 'scale_surveys'

  get 'score_reports/create', :to => 'score_reports#create', :as => 'create_score_report'
  
  # post 'answer_charts/show/(/:id)', :to => 'answer_charts#show', :as => 'answer_chart', :via => [:post]
  
  get 'registration', :to => 'active_rbac/registration#lostpassword', :as => 'lostpassword'
  # is this used?
  get 'registration', :to => 'active_rbac/registration#registration', :as => 'registration'


  # survey builder
  # get 'survey_builders/show_edit/(/:id)', :to => 'survey_builders#show_edit', :as => 'show_edit_survey_builder'
  get 'survey_builders/save_question/(/:id)', :to => 'survey_builders#save_question', :as => 'save_question_survey_builder'
  get 'survey_builders/add_question/(/:id)', :to => 'survey_builders#add_question', :as => 'add_question_survey_builder'
  # get 'survey_builders/edit/(/:id)', :to => 'survey_builders#edit', :as => 'edit_survey_builder'
  # get 'survey_builders/new', :to => 'survey_builders#new', :as => 'new_survey_builder'

  get 'survey_builders/add_question_row', :to => 'survey_builders#add_question_row', :as => 'add_question_row'
  get 'survey_builders/delete_question_row', :to => 'survey_builders#delete_question_row', :as => 'delete_question_row'
  get 'survey_builders/add_question_column', :to => 'survey_builders#add_question_column', :as => 'add_question_column'
  get 'survey_builders/delete_question_column', :to => 'survey_builders#delete_question_column', :as => 'delete_question_column'

  get 'survey_builders/change_form/(/:id)', :to => 'survey_builders#change_form', :as => 'change_form'
  get 'survey_builders/change_back_form/(/:id)', :to => 'survey_builders#change_back_form', :as => 'change_back_form'
  
  # get 'survey_builder/destroy', :to => 'survey_builder#destroy', :as => 'destroy', :method => 'delete'


  # scope path: "/api" do
  get '/api/answer_reports/show/(/:api_key)/(/:token)', :to => 'api/answer_reports#show', :as => 'api_answer_report'
  get '/api/export/csv_raw/(:api_key)/(:token)', :to => 'api/export#csv_raw', :as => 'api/export_csv_raw'      # :id is login_user

  # end


  get '/register/confirm/:user/:token', :to => 'active_rbac/registration#confirm'
  # get '/register/:action/(/:id)', :controller => 'active_rbac/registration'
  # get '/registration/lostpassword', :controller => 'active_rbac/registration', :action => :lostpassword

  # get '/exports/:action/(/:id)', :controller => 'exports', :action => :team, :id => :id
  
  # testing
  # get '/myaccount/:action/(/:id)', :controller => 'active_rbac/my_account'

  get '/export_logins/:action/:id.:format', :to => 'export_logins#download'
  # get '/reminders/:action/:id.:format', :to => 'reminders#download', :as => 'download'

  get "*all" => "api_login#cors_preflight_check", :constraints => { :method => "OPTIONS" }
  post '/api_login/create/', :to => 'api_login#create'
  post '/api_login/open/', :to => 'api_login#open'
  get '/api_login/index/:api_key', :to => 'api_login#index'
  post '/api_login/index/', :to => 'api_login#index'

  get '/api/login/:api_key/:token', :to => 'api/login#login', :as => "api_login"
  get '/api/start/:api_key/:token', :to => 'api/start#start', :as => "api_survey_start"
  # get '/api/start/start/:api_key/:token', :to => 'api/start#start', :as => "api_survey_start"
  # post '/api_login/open/', :to => 'api_login#open'
  # post '/api_login/index/', :to => 'api_login#index'

  # post '/api_login/show/', :to => 'api_login#show'



  get 'main', :to => 'main#index', :as => 'main'
  root :to => 'login#index'
  get '', :to => 'login#index'

  # hide '/active rbac/*'
  #get '/active_rbac/*foo', :controller => 'error'
  
  #get 'signup', :controller => 'login', :action => :signup

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # get ':controller/service.wsdl', :action => :wsdl

  # Install the default route as the lowest priority.
  get ':controller(/:action(/:id))'
  # get ':controller/:action/:id.:format'
  
  # error handling
  get '*path', :to => 'application#rescue_404' # unless ::ActionController::Base.consider_all_requests_local
end
