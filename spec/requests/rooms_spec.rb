# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  describe 'GET /rooms' do
    subject(:request) { get team_rooms_path(team_id: team_id), headers: { 'X-Requested-With' => 'XMLHttpRequest' } }

    context 'ログインしている場合' do
      let(:user) { create(:user, :confirmed) }

      before do
        log_in user
      end

      context 'ユーザが管理者のチームのルームが存在する場合' do
        let(:team) { create(:team, user: user) }
        let(:room) { create(:room, team: team) }
        let(:team_id) { team.id }

        before do
          room
        end

        it 'ルーム一覧が取得できること' do
          request
          expect(parsed_response_body).to eq({ rooms: [{ id: room.id, name: room.name }] })
        end
      end

      context 'ユーザが参加しているチームのルームが存在する場合' do
        let(:team_users) { create(:team_user, :other_team_user, user: user) }
        let(:room) { create(:room, team: team_users.team) }
        let(:team_id) { team_users.team.id }

        before do
          room
        end

        it 'ルーム一覧が取得できること' do
          request
          expect(parsed_response_body).to eq({ rooms: [{ id: room.id, name: room.name }] })
        end
      end

      context 'ユーザが管理しているチームでルームが存在しない場合' do
        let(:team) { create(:team, user: user) }
        let(:team_id) { team.id }

        it 'ルーム一覧が空で取得できること' do
          request
          expect(parsed_response_body).to eq({ rooms: [] })
        end
      end

      context 'ユーザが参加しているチームでルームが存在しない場合' do
        let(:team_users) { create(:team_user, :other_team_user, user: user) }
        let(:team_id) { team_users.team.id }

        it 'ルーム一覧が空で取得できること' do
          request
          expect(parsed_response_body).to eq({ rooms: [] })
        end
      end

      context 'ユーザが管理・参加していないチームを要求した場合' do
        let(:team_id) { 1 }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:team_id) { 1 }

      it '404が起きること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /rooms/:id' do
    subject(:request) do
      get team_room_path(team_id: team_id, id: room_id), headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    context 'ログインしている場合' do
      let(:user) { create(:user, :confirmed) }

      before do
        log_in user
      end

      context 'ユーザが管理者のチームのルームが存在する場合' do
        let(:team) { create(:team, user: user) }
        let(:room) { create(:room, team: team) }
        let(:team_id) { team.id }
        let(:room_id) { room.id }

        it 'ルームが取得できること' do
          request
          expect(parsed_response_body).to eq({ id: room.id, name: room.name })
        end
      end

      context 'ユーザが参加しているチームのルームが存在する場合' do
        let(:team_users) { create(:team_user, :other_team_user, user: user) }
        let(:room) { create(:room, team: team_users.team) }
        let(:team_id) { team_users.team.id }
        let(:room_id) { room.id }

        it 'ルームが取得できること' do
          request
          expect(parsed_response_body).to eq({ id: room.id, name: room.name })
        end
      end

      context 'ユーザが管理しているチームでルームが存在しない場合' do
        let(:team) { create(:team, user: user) }
        let(:room) { create(:room, team: team) }
        let(:team_id) { team.id }
        let(:room_id) { 1 }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'ユーザが参加しているチームでルームが存在しない場合' do
        let(:team_users) { create(:team_user, :other_team_user, user: user) }
        let(:room) { create(:room, team: team_users.team) }
        let(:team_id) { team_users.team.id }
        let(:room_id) { 1 }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'ユーザが管理・参加していないチームを要求した場合' do
        let(:room) { create(:room, :other_team) }
        let(:team_id) { room.team.id }
        let(:room_id) { room.id }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:team_id) { 1 }
      let(:room_id) { 1 }

      it '404が起きること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
