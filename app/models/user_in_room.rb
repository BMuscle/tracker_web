# frozen_string_literal: true

class UserInRoom < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :room_id, uniqueness: { scope: :user_id }
  validates :user_id, uniqueness: true
end
