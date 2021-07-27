# frozen_string_literal: true

FactoryBot.define do
  factory :team_user do
    trait :other_team_user do
      user { association :user }
      team { association :team, :other_team }
    end
  end
end
