class User < ApplicationRecord
  
  # has_many ~と記述,また多数所持するため、複数形（attendances）userが親attendancesが子
# ruby:Userモデルデータが削除されると、関連するAttendanceモデルのデータもまとめて削除される
 has_many :attendances, dependent: :destroy
  
  # 「remember_token」という仮想の属性を作成します。
  attr_accessor :remember_token
  
  before_save {self.email=email.downcase}
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true        
                    
   # inオプションを指定,範囲オブジェクトである2..30を設定することで、目的である「2文字以上かつ30文字以下」という検証を追加
  # 値が空文字""の場合バリデーションをスルーします
    validates :department, length: { in: 2..30 }, allow_blank: true
    
  validates :basic_time, presence: true
  validates :work_time, presence: true
   
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  
   # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  # 標準ライブラリSecureRandomモジュールにあるurlsafe_base64メソッドA~Z a~z 0~9 （全部で64通り）から生成される22文字の文字列を返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # rememberメソッドは永続セッションのためハッシュ化したトークンを、データベースに記憶することが目的です。
  # has_secure_passwordでは自動的にpasswordカラムを仮想属性として扱えるようにする機能がありました そのためattr_accessorを使って、user.remember_tokenメソッドを使えるよう実装


 # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    # 「ハッシュ化されたトークン情報」を代入
    self.remember_token = User.new_token
    # トークンダイジェストを更新
    update_attribute(:remember_digest, User.digest(remember_token))
  end

 
  
  # トークンがダイジェストと一致すればtrueを返します。
  # トークンがダイジェストと一致すればtrueを返します。
# bcryptを使って、cookiesに保存されているremember_tokenがデータベースにあるremember_digestと一致することを確認します。（トークン認証）
def authenticated?(remember_token)
  # ダイジェストが存在しない場合はfalseを返して終了します。
  return false if remember_digest.nil?
  BCrypt::Password.new(remember_digest).is_password?(remember_token)
end
  
   # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end
