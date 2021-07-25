# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Teams::Invites', type: :request do
  describe 'PUT /update' do
    subject(:request) do
      put teams_invite_path(team_id), headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user) { create(:confirmed_user) }

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
end
