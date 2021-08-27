# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInRoomChannel, type: :channel do
  before do
    stub_connection
  end

  describe 'メッセージの送信' do
    describe 'User#leave_room' do
      subject(:leave) { user.leave_room }

      let(:user_in_room) { create(:user_in_room, :other_room_and_user) }
      let(:room) { user_in_room.room }
      let(:team) { room.team }
      let(:user) { user_in_room.user }

      before do
        subscribe(team_id: team.id)
      end

      it '退出したことが送信されること' do
        expect { leave }.to have_broadcasted_to("user_in_room_#{team.id}").with(
          message: 'leaved',
          rooms: [{ id: room.id, name: room.name, users: [] }]
        )
      end
    end

    describe 'Team.broadcast_rooms' do
      subject(:broadcast_rooms) { Team.broadcast_rooms(team.id, 'participated') }

      let(:user_in_room) { create(:user_in_room, :other_room_and_user) }
      let(:room) { user_in_room.room }
      let(:team) { room.team }
      let(:user) { user_in_room.user }

      before do
        subscribe(team_id: team.id)
      end

      it 'ルームに参加したことが送信されること' do
        expect { broadcast_rooms }.to have_broadcasted_to("user_in_room_#{team.id}").with(
          message: 'participated',
          rooms: [{ id: room.id, name: room.name, users: [{ id: user.id }] }]
        )
      end
    end
  end
end
