# 8. 5. 1 管理権限属性を追加


class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    # データ型はbooleanとします。（trueかfalseを持つ）
    add_column :users, :admin, :boolean,  default: false
  end
end
