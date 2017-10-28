#ruby=2.4.1
#ruby-gemset=tpr-cordinator-241

ruby '2.4.1'

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'uuidtools'
gem 'useragent'
gem 'active_model_serializers'
gem 'httparty'
gem 'json'
gem 'validates_email_format_of'
gem 'gmail'

# Because of the change in type casting in ruby 2.4.x
gem 'bigdecimal'

# API Documentation Engine
gem "apitome"

# Monitoring
# gem 'skylight'
gem 'bugsnag'

# Shipstation API gem
gem 'shippo', '~> 3.0', '>= 3.0.1'
gem 'tracking_number'

# paaaaaaaaaagination
gem 'api-pagination'
gem 'kaminari'

gem 'faker'

gem 'rack-attack'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec_api_documentation'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'timecop'
  gem 'simplecov'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data'
