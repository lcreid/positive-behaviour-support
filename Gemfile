source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'

gem 'bootsnap'

# Use sqlite3 as the database for Active Record
# include it in all environments or the build won't work.
gem 'sqlite3'

# Use mysql2 in production
group :production, :staging do
  gem 'mysql2'
end

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# From: http://railscasts.com/episodes/241-simple-omniauth-revised
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-yahoo'
gem 'omniauth-facebook'

gem 'humanize_boolean'
gem 'capistrano', '~> 3.1'
gem 'capistrano-bundler'

gem 'whenever', require: false

gem 'detect_timezone_rails'

gem 'kaminari' # Pagination From http://railscasts.com/episodes/254-pagination-with-kaminari

gem 'validates_timeliness', '~> 4.0'

group :test do
  gem 'capybara'
  gem 'capybara_minitest_spec'
  gem 'capybara-webkit'
  gem 'capybara-email'
  gem 'database_cleaner'
end

group :test, :development do
  gem 'timecop'
end

group :development do
  gem 'capistrano-rails', '~> 1.1'
end

# FIXME: These were added in transition to Rails 5.0. Remove later.
gem 'record_tag_helper', '~> 1.0'
gem 'rails-controller-testing'
