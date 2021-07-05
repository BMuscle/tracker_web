# frozen_string_literal: true

require 'capybara/rspec'

Capybara.register_driver :remote_chrome do |app|
  url = 'http://0.0.0.0:4444/wd/hub'
  caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:chromeOptions' => {
      'args' => [
        'no-sandbox',
        'headless',
        'disable-gpu',
        'window-size=1680,1050'
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, desired_capabilities: caps)
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 3000
    Capybara.app_host = "http://#{Rails.configuration.capybara_app_host}:3000"
  end
end
