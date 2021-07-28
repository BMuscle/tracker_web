# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'Validation' do
    subject { room.valid? }

    context '正常系' do
      let(:room) { build(:room, :other_team_room) }

      it { is_expected.to eq(true) }
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'nameがない場合' do
        let(:room) { build(:room, :other_team_room, name: nil) }

        it_behaves_like 'invalid'
      end

      context 'nameが0文字の場合' do
        let(:room) { build(:room, :other_team_room, name: '') }

        it_behaves_like 'invalid'
      end

      context 'nameが30文字より多い場合' do
        let(:room) { build(:room, :other_team_room, name: 'a' * 31) }

        it_behaves_like 'invalid'
      end

      context '同じチームで重複するnameの場合' do
        let(:team) { create(:team, :other_team) }
        let(:room) { build(:room, team: team, name: 'sample') }

        before do
          create(:room, team: team, name: 'sample')
        end

        it_behaves_like 'invalid'
      end
    end
  end
end
