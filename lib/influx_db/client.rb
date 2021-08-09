# frozen_string_literal: true

module InfluxDb
  class Client
    attr_reader :user_id, :write_api, :query_api, :client

    STATUS_CODE_OF_NO_CONTENT = '204'

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def initialize(user_id)
      host = Rails.configuration.influx_db['host']
      user = Rails.configuration.influx_db['user']
      password = Rails.configuration.influx_db['password']
      org = Rails.configuration.influx_db['org']
      bucket = Rails.configuration.influx_db['bucket']
      @client = InfluxDB2::Client.new(
        host,
        "#{user}:#{password}",
        bucket: bucket,
        org: org,
        use_ssl: false,
        precision: InfluxDB2::WritePrecision::NANOSECOND
      )
      @write_api = client.create_write_api
      @query_api = client.create_query_api
      @user_id = user_id.to_s
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def write(data)
      write_api.write(data: data)&.code == STATUS_CODE_OF_NO_CONTENT
    end
  end
end
