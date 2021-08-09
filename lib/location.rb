# frozen_string_literal: true

class Location
  attr_reader :latitude, :longitude

  def initialize(value)
    position = JSON.parse(value, symbolize_names: true)
    @latitude = position[:latitude]&.to_f
    @longitude = position[:longitude]&.to_f
  end
end
