# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserInRooms', type: :request do
  describe 'POST /user_in_rooms' do
    context 'ユーザーがログインしている場合' do
      subject(:request) do
        post team_user_in_rooms_path(team_id),
             params: params,
             headers: xhr_headers
      end

      before do
        log_in user
      end

      context 'ユーザが参加しているチームの場合' do
        let(:room) { create(:room, :other_team_room) }
        let(:user) { room.team.user }
        let(:team_id) { room.team_id }
        let(:params) { { room: { id: room.id } } }

        it 'no contentが返ること' do
          request
          expect(response).to have_http_status(:no_content)
        end

        it 'ルームにユーザが参加していること' do
          request
          expect(room.users.exists?(id: room.team.user.id)).to eq(true)
        end

        it 'ユーザが参加したことがブロードキャストから送信されること' do
          expect { request }.to have_broadcasted_to("user_in_room_#{team_id}").with(
            message: 'participated',
            rooms: [{ id: room.id, name: room.name, users: [{ id: user.id }] }]
          )
        end
      end

      context 'ユーザが既に参加しているルームの場合' do
        let(:room) { create(:room, :other_team_room) }
        let(:user) { room.team.user }
        let(:team_id) { room.team_id }
        let(:params) { { room: { id: room.id } } }

        before do
          UserInRoom.create(room: room, user: user)
        end

        it 'no contentが返ること' do
          request
          expect(response).to have_http_status(:no_content)
        end

        it 'ルームにユーザが参加していること' do
          request
          expect(room.users.exists?(id: room.team.user.id)).to eq(true)
        end

        it 'ユーザが退出したことがブロードキャストから送信されること' do
          expect { request }.to have_broadcasted_to("user_in_room_#{team_id}").with(
            message: 'leaved',
            rooms: [{ id: room.id, name: room.name, users: [] }]
          )
        end

        it 'ユーザが参加したことがブロードキャストから送信されること' do
          expect { request }.to have_broadcasted_to("user_in_room_#{team_id}").with(
            message: 'participated',
            rooms: [{ id: room.id, name: room.name, users: [{ id: user.id }] }]
          )
        end
      end

      context '存在しないルームの場合' do
        let(:user) { create(:user, :confirmed) }
        let(:team) { create(:team, user: user) }
        let(:team_id) { team.id }
        let(:params) { { room: { id: 1 } } }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'ユーザが参加していないチームのルームの場合' do
        let(:room) { create(:room, :other_team_room) }
        let(:team_id) { room.team_id }
        let(:user) { create(:user, :confirmed) }
        let(:params) { { room: { id: room.id } } }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'ユーザがルームに参加していないこと' do
          expect(room.users.exists?(id: user.id)).to eq(false)
        end
      end

      context 'チームが存在しない場合' do
        let(:user) { create(:user, :confirmed, :with_agent) }
        let(:team_id) { 1 }
        let(:params) { { room: { id: 1 } } }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'ユーザがログインしていない場合' do
      subject(:request) do
        post team_user_in_rooms_path(team_id),
             params: params,
             headers: xhr_headers
      end

      context 'ユーザが参加しているチームの場合' do
        let(:room) { create(:room, :other_team_room) }
        let(:user) { room.team.user }
        let(:team_id) { room.team_id }
        let(:params) { { room: { id: room.id } } }

        it '404が返ること' do
          request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
