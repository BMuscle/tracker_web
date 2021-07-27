# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'Validation' do
    subject { room.valid? }

    context '正常系' do
      let(:room) { build(:room, :team) }

      it { is_expected.to eq(true) }
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'nameがない場合' do
        let(:room) { build(:room, :team, name: nil) }

        it_behaves_like 'invalid'
      end

      context 'nameが0文字の場合' do
        let(:room) { build(:room, :team, name: '') }

        it_behaves_like 'invalid'
      end

      context 'nameが30文字より多い場合' do
        let(:room) { build(:room, :team, name: 'a' * 31) }

        it_behaves_like 'invalid'
      end
    end
  end
end
