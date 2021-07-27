# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamUser, type: :model do
  describe 'Validation' do
    subject { team_user.valid? }

    let(:user) { create(:user) }
    let(:management_user) { create(:user) }
    let(:team) { create(:team, user: management_user) }

    context '正常系' do
      let(:team_user) { build(:team_user, user: user, team: team) }

      it { is_expected.to eq(true) }
    end

    context '関連へのアクセス' do
      let(:team_user) { create(:team_user, user: user, team: team) }

      before do
        team_user
      end

      it '関連が取得できること' do
        aggregate_failures do
          expect(team.participating_users.first).to eq(user)
          expect(user.participating_teams.first).to eq(team)
          expect(management_user.management_teams.first).to eq(team)
        end
      end
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'teamがない場合' do
        let(:team_user) { build(:team_user, user: user, team: nil) }

        it_behaves_like 'invalid'
      end

      context 'userがない場合' do
        let(:team_user) { build(:team_user, user: nil, team: team) }

        it_behaves_like 'invalid'
      end

      context 'teamの参照先がない場合' do
        let(:team_user) { build(:team_user, user: user, team_id: 1) }

        it_behaves_like 'invalid'
      end

      context 'userの参照先がない場合' do
        let(:team_user) { build(:team_user, user_id: 1, team: team) }

        it_behaves_like 'invalid'
      end
    end
  end
end
