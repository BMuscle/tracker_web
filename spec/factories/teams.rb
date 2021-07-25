# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "team_#{n}" }

    factory :team_invite do
      after(:create, &:update_invite)
    end
  end
end
