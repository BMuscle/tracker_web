# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.references :team, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
