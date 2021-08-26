# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AgentApi::UserInRooms', type: :request do
  describe 'POST /user_in_rooms' do
    context '認証情報が正しい場合' do
      subject(:request) do
        post agent_api_team_user_in_rooms_path(team_id),
             params: {
               agent_guid: user.agent.guid,
               token: user.agent.token
             }.merge(params),
             headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      context 'ユーザが参加しているチームの場合' do
        let(:room) { create(:room, :other_team_room).tap { |room| create(:agent, user: room.team.user) } }
        let(:user) { room.team.user }
        let(:team_id) { room.team_id }
        let(:params) { { room: { id: room.id } } }

        before do
          request
        end

        it 'no contentが返ること' do
          expect(response).to have_http_status(:no_content)
        end

        it 'ルームにユーザが参加していること' do
          expect(room.users.exists?(id: room.team.user.id)).to eq(true)
        end
      end

      context 'ユーザが既に参加しているチームの場合' do
        let(:room) { create(:room, :other_team_room).tap { |room| create(:agent, user: room.team.user) } }
        let(:user) { room.team.user }
        let(:team_id) { room.team_id }
        let(:params) { { room: { id: room.id } } }

        before do
          UserInRoom.create(room: room, user: user)
          request
        end

        it 'no contentが返ること' do
          expect(response).to have_http_status(:no_content)
        end

        it 'ルームにユーザが参加していること' do
          expect(room.users.exists?(id: room.team.user.id)).to eq(true)
        end
      end

      context '存在しないルームの場合' do
        let(:user) { create(:user, :confirmed, :with_agent) }
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
        let(:user) { create(:user, :confirmed, :with_agent) }
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

    context '認証情報が正しくない場合' do
      subject(:request) do
        post agent_api_team_user_in_rooms_path(team_id),
             params: {
               agent_guid: 'xxx',
               token: 'xxx'
             }.merge(params),
             headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      context 'ユーザが参加しているチームの場合' do
        let(:room) { create(:room, :other_team_room).tap { |room| create(:agent, user: room.team.user) } }
        let(:user) { room.team.user }
        let(:team_id) { room.team_id }
        let(:params) { { room: { id: room.id } } }

        it 'RecordNotFoundが起きること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
