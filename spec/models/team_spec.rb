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
end
