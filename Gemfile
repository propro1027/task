source 'https://rubygems.org'

gem 'rails',        '~> 5.1.6'
# bootstrap
gem 'bootstrap-sass' 

# パスワードをハッシュ化する
gem 'bcrypt'

gem 'faker' # 実際に存在していそうな名前を生成してくれる

# ページネーション機能を追加
gem 'will_paginate' 
# ページネーションのデザインをお手軽に良くする
gem 'bootstrap-will_paginate' 

# ailsアプリケーションの日本語化や国際化
gem 'rails-i18n' 


gem 'puma',         '~> 3.7'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]