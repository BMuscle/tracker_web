# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "room_#{n}" }
    trait :team do
      association :team
    end
  end
end
