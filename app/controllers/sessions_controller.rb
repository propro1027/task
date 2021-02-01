class SessionsController < ApplicationController
  def new
  end
  
  def create
    # params[:session][:email] # "sample@email.com" を取得する
    # params[:session][:password] # "password" を取得する
    
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン後にユーザー情報ページにリダイレクトします。
      log_in user
      # 三項演算子」の構造[条件式] ? [真（true）の場合実行される処理] : [偽（false）の場合実行される処理]
      # オンの時はユーザー情報を記憶します。# オフの場合は記憶しません。
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      # ここにはエラーメッセージ用のflashを入れます。
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
  # ログイン中の場合のみログアウト処理を実行します。
  log_out if logged_in?
  flash[:success] = 'ログアウトしました。'
  redirect_to root_url
  end
end
  

