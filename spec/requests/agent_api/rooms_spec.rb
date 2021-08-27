# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AgentApi::Rooms', type: :request do
  describe 'GET /rooms' do
    context '認証情報が正しい場合' do
      subject(:request) do
        get agent_api_rooms_path(team_id: team_id),
            headers: agent_headers(user.agent.guid, user.agent.token)
      end

      let(:user) { create(:user, :confirmed, :with_agent) }

      context 'ユーザが管理者のチームのルームが存在する場合' do
        let(:team) { create(:team, user: user) }
        let(:room) { create(:room, team: team) }
        let(:team_id) { team.id }

        before do
          room
        end

        it 'ルーム一覧が取得できること' do
          request
          expect(parsed_response_body).to eq({ rooms: [{ id: room.id, name: room.name, users: [] }] })
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
          expect(parsed_response_body).to eq({ rooms: [{ id: room.id, name: room.name, users: [] }] })
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

    context '認証情報が正しくない場合' do
      subject(:request) do
        get agent_api_rooms_path(team_id: team_id, agent_guid: 'xxxx', token: 'xxxx'),
            headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      let(:team_id) { 1 }

      it 'RecordNotFoundが起きること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET /rooms/:id' do
    context '認証情報が正しい場合' do
      subject(:request) do
        get agent_api_room_path(team_id: team_id, id: room_id),
            headers: agent_headers(user.agent.guid, user.agent.token)
      end

      let(:user) { create(:user, :confirmed, :with_agent) }

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
        let(:room) { create(:room, :other_team_room) }
        let(:team_id) { room.team.id }
        let(:room_id) { room.id }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context '認証情報が正しくない場合' do
      subject(:request) do
        get agent_api_room_path(team_id: team_id, id: room_id, agent_guid: 'xxxx', token: 'xxxx'),
            headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      let(:team_id) { 1 }
      let(:room_id) { 1 }

      it 'RecordNotFoundが起きること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
