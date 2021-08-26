# frozen_string_literal: true

FactoryBot.define do
  factory :agent do
    trait :other_user do
      association :user, :confirmed
    end
  end
end
