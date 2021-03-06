# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :confirmed do
      after(:create, &:confirm)
    end

    trait :with_agent do
      after(:create) do |user|
        FactoryBot.create(:agent, user: user)
      end
    end
  end
end
