# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :team
  belongs_to :room, optional: true

  validate :room_and_team_match # 保存時にルームを指定している場合、チームに含まれている必要がある

  def room_and_team_match
    errors.add(:room, ' is not included in the team') if room&.team_id && room&.team_id != team_id
  end
end
