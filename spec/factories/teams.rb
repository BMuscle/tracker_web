# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "team_#{n}" }

    trait :invited do
      after(:create, &:update_invite!)
    end

    trait :other_team do
      association :user, :confirmed
    end
  end
end
