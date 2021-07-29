# frozen_string_literal: true

FactoryBot.define do
  factory :user_in_room do
    trait :other_room_and_user do
      user { association :user }
      room { association :room, :other_team_room }
    end
  end
end
