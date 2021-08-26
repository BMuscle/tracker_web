# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AgentApi::Teams', type: :request do
  describe 'GET /teams' do
    context '認証情報が正しい場合' do
      subject(:request) do
        get agent_api_teams_path(agent_guid: user.agent.guid, token: user.agent.token),
            headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      let(:user) { create(:user, :confirmed, :with_agent) }

      context 'ユーザが作成しているチームが存在する場合' do
        let(:team) { create(:team, user: user) }

        before do
          team
        end

        it '作成しているチームが返ること' do
          request
          expect(parsed_response_body).to eq({ teams: [{ id: team.id, name: team.name }] })
        end
      end

      context 'ユーザが参加しているチームが存在する場合' do
        let(:management_user) { create(:user, :confirmed) }
        let(:team) { create(:team, user: management_user) }
        let(:team_user) { create(:team_user, user: user, team: team) }

        before do
          team_user
        end

        it '参加しているチームが返ること' do
          request
          expect(parsed_response_body).to eq({ teams: [{ id: team.id, name: team.name }] })
        end
      end
    end

    context '認証情報が正しくない場合' do
      subject(:request) do
        get agent_api_teams_path(agent_guid: 'xxxxxx', token: 'xxxxx'),
            headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      it 'RecordNotFoundが起きること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET /teams/:id' do
    context '認証情報が正しい場合' do
      subject(:request) do
        get agent_api_team_path(id: team_id, agent_guid: user.agent.guid, token: user.agent.token),
            headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      let(:user) { create(:user, :confirmed, :with_agent) }

      context 'チームの参加者の場合' do
        let(:invite_team) { create(:team_user, :other_team_user, user: user) }
        let(:team_id) { invite_team.team_id }

        it '参加チームの情報が返ること' do
          request
          expect(parsed_response_body).to eq({ id: invite_team.team_id, name: invite_team.team.name, invite_guid: nil,
                                               invite_expired: true })
        end
      end

      context 'チームの作成者の場合' do
        let(:team) { create(:team, user: user) }
        let(:team_id) { team.id }

        it '作成チームの情報が返ること' do
          request
          expect(parsed_response_body).to eq({ id: team.id, name: team.name, invite_guid: nil, invite_expired: true })
        end
      end

      context 'チームが存在しない場合' do
        let(:team_id) { 1 }

        it 'RecordNotFoundが発生すること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context '認証情報が正しくない場合' do
      subject(:request) do
        get agent_api_team_path(id: team_id, agent_guid: 'xxxx', token: 'xxxx'),
            headers: { 'X-Requested-With' => 'XMLHttpRequest' }
      end

      let(:user) { create(:user, :confirmed, :with_agent) }
      let(:invite_team) { create(:team_user, :other_team_user, user: user) }
      let(:team_id) { invite_team.team_id }

      it 'RecordNotFoundが起きること' do
        expect { request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
