# frozen_string_literal: true

class Agent < ApplicationRecord
  include IdGenerator

  belongs_to :user

  before_create :set_guid

  validates :user_id, uniqueness: true
  validates :guid, uniqueness: true
  validates :token, presence: true

  attribute :token, :string, default: -> { SecureRandom.urlsafe_base64(32) }

  def set_guid
    self.guid = generate_uuid(:guid)
  end
end
