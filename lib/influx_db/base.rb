# frozen_string_literal: true

module InfluxDb
  class Base
    STATUS_CODE_OF_NO_CONTENT = '204'

    def initialize(user_id)
      @client = InfluxDb::Client.new(user_id)
    end

    private

    def write(data)
      @client.write_api.write(data: data)&.code == STATUS_CODE_OF_NO_CONTENT
    end

    def convert_time(time)
      if time.nil?
        Time.zone.now
      elsif time.instance_of?(String)
        Time.zone.parse(time)
      elsif time.instance_of?(Time)
        time
      else
        raise ArgumentError, 'time is require as string or time'
      end
    end
  end
end
