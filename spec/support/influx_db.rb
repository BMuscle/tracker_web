# frozen_string_literal: true

RSpec.shared_context 'use influx', use_influx: true do
  before do
    Rails.configuration.influx_db['bucket'] = Rails.configuration.influx_db['test_bucket']
  end

  after do
    InfluxDb::Client.new(0).client.create_delete_api.delete('1970-01-01T00:00:00Z', '2250-01-01T00:00:00Z')
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'use influx', use_influx: true
end
