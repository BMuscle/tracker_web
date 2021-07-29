# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :team
  has_many :user_in_rooms, dependent: :destroy
  has_many :users, through: :user_in_rooms, source: :user

  validates :team_id, uniqueness: { scope: :name }
  validates :name, presence: true, length: { maximum: 30 }
end
