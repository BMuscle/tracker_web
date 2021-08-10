# frozen_string_literal: true

module InfluxDb
  class Client
    attr_reader :user_id, :write_api, :query_api, :client, :bucket

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def initialize(user_id)
      host = Rails.configuration.influx_db['host']
      org = Rails.configuration.influx_db['org']
      token = Rails.configuration.influx_db['token']
      @bucket = Rails.configuration.influx_db['bucket']
      @client = InfluxDB2::Client.new(
        host,
        token,
        bucket: @bucket,
        org: org,
        use_ssl: false,
        precision: InfluxDB2::WritePrecision::NANOSECOND
      )
      @write_api = client.create_write_api
      @query_api = client.create_query_api
      @user_id = user_id.to_s
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
