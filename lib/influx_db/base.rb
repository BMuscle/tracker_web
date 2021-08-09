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
  end
end
