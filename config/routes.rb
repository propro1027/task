Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup',to: 'users#new'


  # ログイン機能 createやdestroyには対応するビューが必要ないため、ここでは指定せずにSessionsコントローラーに直接追加
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # モーダルウインドウを表示
  # 今回はUsersリソースにメンバー（member）ルーティングを追加する手法
   resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
    
    
    resources :attendances, only: :update # Attendancesリソースを使用しますが、updateアクションのみで良い為次のように記述します。
  end
end
