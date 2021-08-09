# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    trait :other_team_game do
      team { association :team, :other_team }
    end
  end
end
