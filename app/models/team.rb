# frozen_string_literal: true

class Team < ApplicationRecord
  include IdGenerator

  belongs_to :user
  has_many :team_users, dependent: :destroy
  has_many :participating_users, through: :team_users, source: :user

  validates :name, presence: true, length: { in: 4..30 }

  scope :can_take_teams, lambda { |current_user|
                           eager_load(:team_users)
                             .where('teams.user_id = ? OR team_users.user_id = ?', current_user.id, current_user.id)
                         }

  def update_invite!
    self.invite_guid = generate_uuid(:invite_guid)
    self.invite_expired = Time.zone.now.since(7.days)
    save!
  end

  def invite_in_expired?
    return true if invite_expired.nil? || invite_guid.nil?

    Time.zone.now > invite_expired
  end
end
