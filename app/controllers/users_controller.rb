class UsersController < ApplicationController
  # 自分以外のユーザーの情報を更新できないよう制御するシステムを実装
  # editとupdateアクションが実行される直前にlogged_in_userメソッドが実行されるようになります。
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  
#   腕の良い攻撃者がコマンドラインからDELETEリクエストを直接発行するという攻撃方法でユーザーを全て削除してしまうことも可能です。
# そのため、destroyアクションには追加で制限を加える必要があります。
  before_action :admin_user, only: :destroy
  # ユーザー一覧
   def index
     @users = User.paginate(page: params[:page])
   end
  
  
  def show
    @user = User.find(params[:id])
    # flash.now[:success] = 'ユーザーの新規作成に成功しましたaaaaa。'
  end

  def new
    @user = User.new # ユーザーオブジェクトを生成し、インスタンス変数に代入します。
  end
  
  def create
    @user = User.new(user_strong)
    if @user.save
       log_in @user # 保存成功後、ログインします。
       flash.now[:success] = '新規作成に成功しました。'
       redirect_to @user
    else
      render :new
    end
  end
  
  #編集
  def edit
   
  end
  
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_strong)
      flash[:success] = "ユーザー情報を更新しました。"
    redirect_to @user
    else
      render :edit      
    end
  end

# 管理者のみアカウント削除できる
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  
  private
  
      def user_strong
        params.require(:user).permit(:name,:email,:password, :password_confirmation)
      end
      
      
# beforeフィルター

    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end

    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
