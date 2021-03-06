class UsersController < ApplicationController
 

 
  # 自分以外のユーザーの情報を更新できないよう制御するシステムを実装
  # editとupdateアクションが実行される直前にlogged_in_userメソッドが実行されるようになります。
before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
before_action :correct_user, only: [:edit, :update]
before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
#   腕の良い攻撃者がコマンドラインからDELETEリクエストを直接発行するという攻撃方法でユーザーを全て削除してしまうことも可能です。
# そのため、destroyアクションには追加で制限を加える必要があります。
  before_action :admin_user, only: :destroy
  before_action :set_one_month, only: :show



  # ユーザー一覧
   def index
     @users = User.paginate(page: params[:page])
   end
  
  
  def show
    
    # @first_dayと@last_dayはshowアクションからこちらへ引っ越すことになります。
    # @user = User.find(params[:id])
  # 当日を取得するためDate.currentを使うこれにRailsのメソッドであるbeginning_of_monthを繋げ当月の初日を取得することが可能
    @first_day = Date.current.beginning_of_month
    # end_of_monthは当月の終日を取得することが可能です。
    @last_day = @first_day.end_of_month
    # 「1ヶ月間で何日出勤したか」を表示
    @worked_sum = @attendances.where.not(started_at: nil).count
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
  
   def edit_basic_info
   end


def update_basic_info
  if @user.update_attributes(basic_info_params)
    flash[:success] = "#{@user.name}の基本情報を更新しました。"
  else
     # エラーメッセージの配列の各要素を区切る際、<br>を使用するよう再設定しました
    flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
  end
  redirect_to users_url
end
  
  private
  
      def user_strong
        params.require(:user).permit(:name,:email, :department, :password, :password_confirmation)
      end
      
      # 編集ページの用意が出来ましたので、仕上げに更新アクション
      def basic_info_params
        params.require(:user).permit(:department, :basic_time, :work_time)
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
