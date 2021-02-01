Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup',to: 'users#new'


  # ログイン機能 createやdestroyには対応するビューが必要ないため、ここでは指定せずにSessionsコントローラーに直接追加
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  
  
  resources:users
end
