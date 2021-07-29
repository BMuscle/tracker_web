# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.references :team, foreign_key: true
      t.string :name
      t.timestamps
    end

    add_index :rooms, %i[team_id name], unique: true
  end
end
