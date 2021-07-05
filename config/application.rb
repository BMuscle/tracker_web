# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrackerWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    yaml_file = YAML.safe_load(ERB.new(Rails.root.join('config/config.yml').read).result)['tracker']
    if File.exist?(Rails.root.join('config/local_config.yml'))
      yaml_file.merge!(YAML.load_file(Rails.root.join('config/local_config.yml'))['tracker'])
    end
    config.capybara_app_host = yaml_file['capybara_app_host']

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.helper false
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       controller_specs: false,
                       routing_specs: false
    end
  end
end
