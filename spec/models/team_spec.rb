# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'Validation' do
    subject { team.valid? }

    let(:user) { create(:user) }

    context '正常系' do
      let(:team) { build(:team, user: user) }

      it { is_expected.to eq(true) }
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'nameがない場合' do
        let(:team) { build(:team, name: nil, user: user) }

        it_behaves_like 'invalid'
      end

      context 'nameが4文字未満の場合' do
        let(:team) { build(:team, user: user, name: 'a' * 3) }

        it_behaves_like 'invalid'
      end

      context 'nameが30文字より大きい場合' do
        let(:team) { build(:team, user: user, name: 'a' * 31) }

        it_behaves_like 'invalid'
      end

      context 'userがない場合' do
        let(:team) { build(:team, user: nil) }

        it_behaves_like 'invalid'
      end

      context 'userの参照先がない場合' do
        let(:team) { build(:team, user_id: 1) }

        it_behaves_like 'invalid'
      end
    end
  end

  describe '#invite_in_expired?' do
    subject { team.invite_in_expired? }

    let(:user) { create(:user) }
    let(:team) { create(:team, user: user) }

    context 'guidとexpiredがnilの場合' do
      before do
        team
      end

      it { is_expected.to eq(true) }
    end

    context '期限内の場合' do
      before do
        team.update_invite!
      end

      it { is_expected.to eq(false) }
    end

    context '期限切れの場合' do
      before do
        team.update_invite!
        travel 7.days
        travel 1.hour
      end

      it { is_expected.to eq(true) }
    end
  end

  describe '.can_take_teams' do
    subject { described_class.can_take_teams(user).pluck(:id) }

    let(:user) { create(:user) }
    let(:other_team) { create(:team, :other_team) }
    let(:other_invite_team) { create(:team_user, :other_team_user) }

    before do
      other_team
      other_invite_team
    end

    context '参加中のチームが1つ管理中のチームが１つ存在する場合' do
      let(:team) { create(:team, user: user) }
      let(:invite_team) { create(:team_user, :other_team_user, user: user) }

      before do
        team
        invite_team
      end

      it { is_expected.to match_array([team.id, invite_team.team_id]) }
    end

    context '参加・管理しているチームがない場合' do
      it { is_expected.to eq([]) }
    end
  end
end
