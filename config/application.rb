require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TprCoordinator
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.logger = Logger.new(STDOUT)
    config.log_level = ENV['LOG_LEVEL'] || 'info'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # configure skylight monitoring
    config.skylight.logger = Logger.new(STDOUT)
    config.skylight.environments += ["test"]
  end
end

ApiPagination.configure do |config|
  # If you have both gems included, you can choose a paginator.
  config.paginator = :kaminari

  # By default, this is set to 'Total'
  config.total_header = 'X-Total'

  # By default, this is set to 'Per-Page'
  config.per_page_header = 'X-Per-Page'

  # Optional: set this to add a header with the current page number.
  config.page_header = 'X-Page'

  # Optional: what parameter should be used to set the page option
  config.page_param = :page

  # Optional: what parameter should be used to set the per page option
  config.per_page_param = :per_page
end
