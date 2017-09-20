Rails.application.routes.draw do
  devise_for :users

 resources :posts do
   member do
     post "like" => "posts#like"
     post "unlike" => "posts#unlike"
   end
 end 

 root "posts#index"

end
