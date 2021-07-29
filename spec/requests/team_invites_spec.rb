# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TeamInvites', type: :request do
  describe 'PUT /update' do
    subject(:request) do
      put invite_teams_path(team_id), headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user) { create(:user, :confirmed) }

    context 'ログイン済みの場合' do
      before do
        log_in user
      end

      context 'コード作成を行う場合' do
        let(:team) { create(:team, user: user, invite_guid: nil, invite_expired: nil) }
        let(:team_id) { team.id }

        before do
          request
          team.reload
        end

        it 'コードが作成されること' do
          aggregate_failures do
            expect(team.invite_expired.present?).to eq(true)
            expect(team.invite_guid.present?).to eq(true)
            expect(parsed_response_body).to include({ id: team.id, invite_guid: team.invite_guid })
          end
        end
      end

      context 'コード更新を行う場合' do
        let(:team) do
          create(:team, user: user, invite_guid: 'xxxxxxxxxxxxxxxx', invite_expired: '2020-01-01T00:00:00+09:00')
        end
        let(:team_id) { team.id }

        before do
          travel_to '2020-01-01T00:00:00'
          request
        end

        it 'コードと期限が更新されること' do
          aggregate_failures do
            expect(parsed_response_body[:invite_guid]).not_to eq(team.invite_guid)
            expect(team.invite_guid.present?).to eq(true)
            expect(team.reload.invite_expired.after?('2020-01-01T00:00:00+09:00')).to eq(true)
          end
        end
      end
    end

    context 'ログインしていない場合' do
      let(:team) { create(:team, user: user, invite_guid: nil, invite_expired: nil) }
      let(:team_id) { team.id }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /invites' do
    subject(:request) do
      post invite_confirm_teams_path, params: { team: { guid: guid } },
                                      headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user) { create(:user, :confirmed) }

    context 'ログイン済みの場合' do
      before do
        log_in user
      end

      context 'ログインユーザが未参加の正しい招待の場合' do
        let(:team) { create(:team, :invited, :other_team) }
        let(:guid) { team.invite_guid }

        it '新規に参加すること' do
          request
          aggregate_failures do
            expect(parsed_response_body).to include({ id: team.id, already: false })
            expect(TeamUser).to exist(user: user, team: team)
          end
        end
      end

      context 'ログインユーザが参加済の正しい招待の場合' do
        let(:team) { create(:team, :invited, :other_team) }
        let(:team_user) { create(:team_user, user: user, team: team) }
        let(:guid) { team.invite_guid }

        before do
          team_user
        end

        it '参加済みの情報が返ること' do
          request
          expect(parsed_response_body).to include({ id: team.id, already: true })
        end
      end

      context 'ログインユーザが管理者の正しい招待の場合' do
        let(:team) { create(:team, :invited, user: user) }
        let(:guid) { team.invite_guid }

        it '参加済みの情報が返ること' do
          request
          expect(parsed_response_body).to include({ id: team.id, already: true })
        end
      end

      context 'ログインユーザが未参加で招待が期限切れの場合' do
        let(:team) { create(:team, :invited, :other_team) }
        let(:guid) { team.invite_guid }

        before do
          travel_to '2020-01-01T00:00:00+09:00'
          team
          travel_to '2020-01-08T00:00:01+09:00'
        end

        it '400が返り、期限切れが分かること' do
          request
          aggregate_failures do
            expect(parsed_response_body).to include({ expired: true })
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context '存在しない招待の場合' do
        let(:guid) { 'xxxxxxxxxxxxxxxx' }

        it 'RecordNotFoundが発生すること' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:team) { create(:team, :invited, :other_team) }
      let(:guid) { team.invite_guid }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
