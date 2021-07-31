# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInRoomChannel, type: :channel do
  before do
    stub_connection
  end

  describe 'メッセージの送信' do
    describe 'User#leave_room' do
      let(:user_in_room) { create(:user_in_room, :other_room_and_user) }
      let(:room) { user_in_room.room }
      let(:team) { room.team }
      let(:user) { user_in_room.user }

      before do
        subscribe(team_id: team.id)
        user.leave_room
      end

      it '退出したことが送信されること' do
        have_broadcasted_to("user_in_room_#{team.id}").with do |data|
          expect(data['message']).to eq('leaved')
        end
      end

      it 'そのチームのルームデータが送信されること' do
        have_broadcasted_to("user_in_room_#{team.id}").with do |data|
          expect(data['rooms']).to eq([{ 'id' => room.id, 'name' => room.name, 'users' => [] }])
        end
      end
    end

    describe 'Team.broadcast_rooms' do
      let(:user_in_room) { create(:user_in_room, :other_room_and_user) }
      let(:room) { user_in_room.room }
      let(:team) { room.team }
      let(:user) { user_in_room.user }

      before do
        subscribe(team_id: team.id)
        Team.broadcast_rooms(team.id, 'participated')
      end

      it 'メッセージが送信されること' do
        have_broadcasted_to("user_in_room_#{team.id}").with do |data|
          expect(data['message']).to eq('leaved')
        end
      end

      it 'そのチームのルームデータが送信されること' do
        have_broadcasted_to("user_in_room_#{team.id}").with do |data|
          expect(data['rooms']).to eq([{ 'id' => room.id, 'name' => room.name, 'users' => [] }])
        end
      end
    end
  end
end
