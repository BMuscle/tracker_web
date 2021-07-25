# frozen_string_literal: true

FactoryBot.define do
  factory :team_user do
    factory :other_team_user do
      association :user
      association :team, factory: :other_team
    end
  end
end
