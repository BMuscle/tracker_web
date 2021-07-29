# frozen_string_literal: true

class CreateUserInRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :user_in_rooms do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true, index: { unique: true }
      t.timestamps
    end

    add_index :user_in_rooms, %i[room_id user_id], unique: true
  end
end
