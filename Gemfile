#ruby=2.4.1
#ruby-gemset=tpr-cordinator-241

ruby '2.4.1'

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test]

gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'uuidtools', '2.1.5'
gem 'useragent', '0.16.9'
gem 'active_model_serializers', '0.10.7'
gem 'httparty', '0.15.6'
gem 'json', '1.8.6'
gem 'gmail'

# Because of the change in type casting in ruby 2.4.x
gem 'bigdecimal', '1.3.4'

# API Documentation Engine
gem 'apitome', '0.1.0'

# Monitoring
# gem 'skylight'
gem 'bugsnag', '6.6.1'

# Shipstation API gem
gem 'shippo', '~> 3.0', '>= 3.0.1'
gem 'tracking_number', '0.10.3'

# paaaaaaaaaagination
gem 'api-pagination', '4.7.0'
gem 'kaminari', '1.2.1'

gem 'faker', '1.8.7'

gem 'rack-attack', '5.0.1'

# Squarespace
gem 'squarespace', '0.0.4'

# QBO APIs
# NOTE: Full OAuth2 support is still in development: https://github.com/ruckus/quickbooks-ruby/issues/389
gem 'quickbooks-ruby', git: 'git://github.com/ruckus/quickbooks-ruby.git', branch: '389-oauth2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry', '0.10.4'
  gem 'pry-nav', '0.2.4'
  gem 'rspec_api_documentation', '5.1.0'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '1.6.2'
  gem 'webmock', '3.2.1'
  gem 'timecop', '0.9.1'
  gem 'simplecov', '0.15.1'
  gem 'fantaskspec', '1.1.0'
  gem 'shoulda-matchers', '3.1.2'
  gem 'table_print'
  gem 'rb-readline'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
