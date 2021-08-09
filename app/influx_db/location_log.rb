# frozen_string_literal: true

class LocationLog < InfluxDb::Base
  def write_log(game, logs = [])
    return false if logs.empty?
    return false unless call_write(game, logs)

    true
  rescue StandardError
    false
  end

  def user_location_log(game)
    query = "from(bucket: \"#{@client.bucket}\")
      |> range(start: 0, stop: now())
      |> filter(fn: (r) =>
          r._measurement == \"#{game.id}\" and
          r.user_id == \"#{@client.user_id}\")"
    @client.query_api.query(query: query)[0]&.records || []
  end

  private

  def call_write(game, logs)
    write(import_location_logs(logs, game))
  end

  def import_location_logs(logs, game)
    [].tap do |array|
      logs.each do |log|
        array << InfluxDB2::Point.new(name: game.id.to_s)
                                 .add_tag('user_id', @client.user_id)
                                 .add_field('location', { latitude: log[:latitude],
                                                          longitude: log[:longitude] }.to_json)
                                 .time(log[:time], InfluxDB2::WritePrecision::NANOSECOND)
      end
    end
  end
end
