class AddIndexTousersEmail < ActiveRecord::Migration[5.1]
  def change
    # usersテーブルのemailカラムのインデックスを作成
    add_index :users, :email, 
               unique: true
  end
end
