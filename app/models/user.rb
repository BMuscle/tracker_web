# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :management_teams, dependent: :destroy, class_name: 'Team'
  has_many :team_users, dependent: :destroy
  has_many :participating_teams, through: :team_users, source: :team
  has_one :user_in_room, dependent: :destroy
  has_one :current_room, through: :user_in_room, source: :room
  has_one :agent, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def can_take_teams
    Team.can_take_teams(self)
  end

  def leave_room
    team_id = user_in_room&.room&.team_id
    return unless team_id

    user_in_room.destroy!
    Team.broadcast_rooms(team_id, 'leaved')
  end
end
