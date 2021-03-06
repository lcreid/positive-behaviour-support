# rubocop:disable Style/StringLiterals

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
gem "bootstrap_form", git: "https://github.com/lcreid/rails-bootstrap-forms.git", branch: "477-collection-block"

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# FIXME: Remove this when I can.
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

gem 'octicons_helper'

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

gem 'where_exists'

group :test do
  gem 'capybara-email'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

group :development do
  gem 'capistrano-rails', '~> 1.1'
end
