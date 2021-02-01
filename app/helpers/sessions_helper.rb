module SessionsHelper
  
   # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    
# ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成されます。
# user.idはsession[:user_id]と記述することで元通りの値を取得することが可能です。
# （ユーザーがブラウザを閉じた瞬間に無効となります）
    session[:user_id] = user.id
  end
  
  
   # 永続的セッションを記憶します（Userモデルを参照）
 
  def remember(user)
    user.remember
      # cookiesは1つのvalue（値）とexpires（有効期限）からでき、Railsでは専用となるpermanentという特殊なメソッドが追加cookiesをブラウザに保存する前に.signedで安全に暗号化するためのものです。署名付きクッキーを設定　 cookies.signed[クッキー名] = 値
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
    # 永続的セッションを破棄します
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  
  # セッションと@current_userを破棄します
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  
   # 一時的セッションにいるユーザーを返します。
  # それ以外の場合はcookiesに対応するユーザーを返します。
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  def current_user
    #user.id=idが1,2など
    if (user_id = session[:user_id])
      #||（or演算子
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
   # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end
  
  #ログイン状態を論理値（trueかfalse）で返すヘルパーメソッド（logged_in?）を定義しましょう。
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  #trueはログイン状態、falseはログアウト状態を表すようにします。そのため否定演算子!を利用します。
   def logged_in?
    !current_user.nil?
   end
  
  # 記憶しているURL(またはデフォルトURL)にリダイレクトします。
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを記憶します。
  def store_location
    # キーは:forwarding_url]
    # リクエストを送ってきたユーザのヘッダー情報や環境変数を取得
　　# request.get?を条件式に指定してGETリクエストのみを記憶するように記述しています。

    session[:forwarding_url] = request.original_url if request.get?
  end
  
  
end
