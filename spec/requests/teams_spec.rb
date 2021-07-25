# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  describe 'GET /teams' do
    subject(:request) { get teams_path, headers: { 'X-Requested-With' => 'XMLHttpRequest' } }

    let(:user) { create(:confirmed_user) }

    context 'ログイン済みの場合' do
      before do
        log_in user
      end

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
        let(:management_user) { create(:confirmed_user) }
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

    context 'ログインしていない場合' do
      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET /teams/:id' do
    subject(:request) do
      get team_path(team_id), headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user) { create(:confirmed_user) }

    context 'ログイン済みの場合' do
      before do
        log_in user
      end

      context 'チームの参加者の場合' do
        let(:invite_team) { create(:other_team_user, user: user) }
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

    context 'ログインしていない場合' do
      let(:invite_team) { create(:other_team_user, user: user) }
      let(:team_id) { invite_team.team_id }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST  /teams' do
    subject(:request) do
      post teams_path, params: { team: team_params }, headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user) { create(:confirmed_user) }

    context 'ログイン済みの場合' do
      before do
        log_in user
      end

      context '正常系' do
        let(:team_params) { { name: 'テストチーム' } }

        it '作成され、値が返ってくること' do
          request
          aggregate_failures do
            expect(parsed_response_body).to eq({ id: Team.first.id, name: Team.first.name, invite_guid: nil,
                                                 invite_expired: true })
          end
        end
      end

      context '値が抜けている場合' do
        let(:team_params) { { name: nil } }

        it 'unprocessable_entityが返ること' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:team_params) { {} }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
