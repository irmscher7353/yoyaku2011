source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'mongrel', '>= 1.2.0.pre2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

require 'sass'
require 'coffee_script'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'

  gem 'therubyracer', :platforms => :ruby
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

gem 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/html_outputter'
