# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

require 'rails_helper'

RSpec.describe 'AgentApi::Locations', type: :request, use_influx: true do
  describe 'POST /locations' do
    subject(:user_location_logs) { LocationLog.new(user_id).user_location_logs(game) }

    let(:request) do
      post agent_api_locations_path,
           params: { location: { logs: logs }, agent_guid: agent_guid, token: token, game_id: game_id,
                     team_id: team_id }
    end

    context 'logが1件の場合' do
      let(:game) { create(:game, :other_team_game).tap { |game| Agent.create(user: game.team.user) } }
      let(:game_id) { game.id }
      let(:team_id) { game.team_id }
      let(:user_id) { game.team.user.id }
      let(:agent_guid) { game.team.user.agent.guid }
      let(:token) { game.team.user.agent.token }
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').iso8601, latitude: '10.001', longitude: '10.001' }] }

      before do
        request
      end

      it '204が返ること' do
        expect(response).to have_http_status(:no_content)
      end

      it 'ログが1件作成されること' do
        expect(user_location_logs.size).to eq(1)
      end
    end

    context 'logが複数件の場合' do
      let(:game) { create(:game, :other_team_game).tap { |game| Agent.create(user: game.team.user) } }
      let(:game_id) { game.id }
      let(:team_id) { game.team_id }
      let(:user_id) { game.team.user.id }
      let(:agent_guid) { game.team.user.agent.guid }
      let(:token) { game.team.user.agent.token }
      let(:logs) do
        [
          { time: Time.parse('2020-01-01t00:00:00z').iso8601, latitude: '10.001', longitude: '20.001' },
          { time: Time.parse('2020-01-01t00:00:01z').iso8601, latitude: '20.001', longitude: '10.001' }
        ]
      end

      before do
        request
      end

      it '204が返ること' do
        expect(response).to have_http_status(:no_content)
      end

      it 'ログが複数件作成されること' do
        expect(user_location_logs.size).to eq(2)
      end
    end

    context 'logが0件の場合' do
      let(:game) { create(:game, :other_team_game).tap { |game| Agent.create(user: game.team.user) } }
      let(:game_id) { game.id }
      let(:team_id) { game.team_id }
      let(:user_id) { game.team.user.id }
      let(:agent_guid) { game.team.user.agent.guid }
      let(:token) { game.team.user.agent.token }
      let(:logs) { [] }

      before do
        request
      end

      it '204が返ること' do
        expect(response).to have_http_status(:no_content)
      end

      it 'ログが作成されないこと' do
        expect(user_location_logs.size).to eq(0)
      end
    end

    context 'ユーザと関係ないgame_idを指定した場合' do
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').iso8601, latitude: '10.001', longitude: '10.001' }] }
      let(:team) { create(:team, :other_team).tap { |team| Agent.create(user: team.user) } }
      let(:team_id) { team.id }
      let(:game_id) { create(:game, :other_team_game).id }
      let(:user_id) { team.user.id }
      let(:agent_guid) { team.user.agent.guid }
      let(:token) { team.user.agent.token }

      it 'RecordNotFoundが発生すること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '存在しないgame_idを指定した場合' do
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').iso8601, latitude: '10.001', longitude: '10.001' }] }
      let(:game_id) { 0 }
      let(:team) { create(:team, :other_team).tap { |team| Agent.create(user: team.user) } }
      let(:team_id) { team.id }
      let(:user_id) { team.user.id }
      let(:agent_guid) { team.user.agent.guid }
      let(:token) { team.user.agent.token }

      it 'RecordNotFoundが発生すること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'パラメータが存在しない場合' do
      subject(:request) { post agent_api_locations_path, params: {} }

      it 'RecordNotFoundが発生すること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

# rubocop:enable RSpec/MultipleMemoizedHelpers
