Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    member do
      post 'like' => 'posts#like'
      post 'unlike' => 'posts#unlike'
      post 'toggle_flag' => 'posts#toggle_flag'
    end
  end

  root 'posts#index'
end
