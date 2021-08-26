# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent, type: :model do
  describe 'Validation' do
    subject { agent.valid? }

    context '正常系' do
      let(:user) { create(:user) }
      let(:agent) { build(:agent, user: user) }

      it { is_expected.to eq(true) }
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'userが重複している場合' do
        let(:user) { create(:user) }
        let(:agent) { build(:agent, user: user) }

        before do
          create(:agent, user: user)
        end

        it_behaves_like 'invalid'
      end

      context 'userがない場合' do
        let(:agent) { build(:agent, user: nil) }

        it_behaves_like 'invalid'
      end
    end
  end
end
