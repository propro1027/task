# スクリプト「書いてすぐ実行できるプログラム」はdb/seeds.rbというファイルに記述します。（すでに存在します）
# スクリプトはrails db:seedで実行可能
# 合計1+999件のサンプルユーザーが生成されます。
# スクリプトはrails db:seedで実行可能です。
# まずはデータベースをここでリセット rails db:migrate:reset
# マイグレーションを実行してからサンプルユーザーを作成 rails db:seed


# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
            # 管理者にadminで権限を与えている？
             admin: true)

39.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end