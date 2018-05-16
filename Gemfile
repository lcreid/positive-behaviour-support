source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgres as the database for Active Record
gem 'pg', "~> 0.18"
gem 'pg_search'
# Use Puma as the app server
gem 'puma', '~> 3.7'

gem 'bootsnap'
gem 'bootstrap', '~> 4.1.0'

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
# FIXME: Remove this when I can.
gem 'coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# FIXME: Remove this when I can.
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# FIXME: I don't think I need this.
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
gem 'bootstrap_form', git: "https://github.com/lcreid/rails-bootstrap-forms.git", branch: "419-check-radio-errors-d"

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

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
