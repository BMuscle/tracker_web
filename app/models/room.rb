# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :team
  validates :team_id, uniqueness: { scope: :name }
  validates :name, presence: true, length: { maximum: 30 }
end
