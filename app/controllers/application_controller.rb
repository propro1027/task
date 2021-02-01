class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # この章でSessionsコントローラーを生成した時に同時に生成されているsessions_helper.rb（ヘルパー）というファイルを使えば、メソッドのパッケージ化ができます。
  include SessionsHelper
end


# コントローラーでこのヘルパーを使いたい場合はモジュールを読み込ませる必要がありますが、
# 全コントローラーの親クラスであるapplication_controller.rbにこのモジュールを読み込ませることで、
# どのコントローラーでもヘルパーに定義したメソッドが使えるようになります。