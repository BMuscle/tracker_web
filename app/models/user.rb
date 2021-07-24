# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :management_teams, dependent: :destroy, class_name: 'Team'
  has_many :team_users, dependent: :destroy
  has_many :participating_teams, through: :team_users, source: :team
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
