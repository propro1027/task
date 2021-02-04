class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # この章でSessionsコントローラーを生成した時に同時に生成されているsessions_helper.rb（ヘルパー）というファイルを使えば、メソッドのパッケージ化ができます。
  include SessionsHelper
  # グローバル変数（プログラムのどこからでも呼び出すことのできる変数）$変数名のように$を用いて表現します。
  # 上記の%w{日 月 火 水 木 金 土}はRubyのリテラル表記と
   $days_of_the_week = %w{日 月 火 水 木 金 土}
end


# コントローラーでこのヘルパーを使いたい場合はモジュールを読み込ませる必要がありますが、
# 全コントローラーの親クラスであるapplication_controller.rbにこのモジュールを読み込ませることで、
# どのコントローラーでもヘルパーに定義したメソッドが使えるようになります。


  
    # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
  @first_day = params[:date].nil? ?
  Date.current.beginning_of_month : params[:date].to_date
  @last_day = @first_day.end_of_month
  one_month = [*@first_day..@last_day]# 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。countメソッドは、対象のオブジェクトが配列の場合要素数を返します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  

 

