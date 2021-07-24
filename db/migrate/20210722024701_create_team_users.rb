# frozen_string_literal: true

class CreateTeamUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :team_users do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_index :team_users, %i[team_id user_id], unique: true
  end
end
