# frozen_string_literal: true

class CreateAgents < ActiveRecord::Migration[6.1]
  def change
    create_table :agents do |t|
      t.references :user, foreign_key: true, index: { unique: true }
      t.string :guid
      t.string :token
      t.timestamps
    end

    add_index :agents, :guid, unique: true
  end
end
