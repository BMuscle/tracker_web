# frozen_string_literal: true

class AddInviteToTeams < ActiveRecord::Migration[6.1]
  def change
    change_table :teams, bulk: true do |t|
      t.column :invite_guid, :string
      t.column :invite_expired, :datetime
    end

    add_index :teams, :invite_guid, unique: true
  end
end
