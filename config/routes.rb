Rails.application.routes.draw do
  get 'duties/index'
  resources :csv_exports
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)
  # get "renewals/index"
  # get "renewals/new"
  # get "renewals/create"

  resources :renewals, except: [:destroy] do
    resources :renewal_payments, only: [:create] do
      collection do
        post :process_payment
      end
    end
  end
  root 'renewals#index'

  resources :contents
  resources :duties, only: [:index]

  namespace :admin do
    # Add dashboard for your models here
    resources :renewals, only: %i[index show] do
      member do
        patch :soft_delete
        patch :undelete
      end
    end
    resources :boats
    # resources :duties
    resources :members, only: %i[index show update] do
      member do
        patch :soft_delete
        patch :undelete
      end
      resources :onboarding, only: [:new, :create]
    end
    resources :onboarding, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch :retry_step
        get :progress
      end
    end
    # resources :contents
    # resources :users
    resources :csv_exports

    root to: 'renewals#index' # <--- Root route
  end

  # Deployment checks
  get '/check.txt', to: proc { [200, {}, ['simple_check']] }

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
end
