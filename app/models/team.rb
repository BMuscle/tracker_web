# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :user
  has_many :team_users, dependent: :destroy
  has_many :participating_users, through: :team_users, source: :user

  validates :name, presence: true, length: { in: 4..30 }
end
