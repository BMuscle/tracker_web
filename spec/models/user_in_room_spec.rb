# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInRoom, type: :model do
  describe 'Validation' do
    subject { user_in_room.valid? }

    context '正常系' do
      let(:user_in_room) { build(:user_in_room, :other_room_and_user) }

      it { is_expected.to eq(true) }
    end

    context '関連へのアクセス' do
      let(:user) { create(:user) }
      let(:room) { create(:room, :team) }
      let(:user_in_room) { create(:user_in_room, user: user, room: room) }

      before do
        user_in_room
      end

      it '関連が取得できること' do
        aggregate_failures do
          expect(room.users.first).to eq(user)
          expect(user.current_room).to eq(room)
        end
      end
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'roomがない場合' do
        let(:user_in_room) { build(:user_in_room, :other_room_and_user, room: nil) }

        it_behaves_like 'invalid'
      end

      context 'userがない場合' do
        let(:user_in_room) { build(:user_in_room, :other_room_and_user, user: nil) }

        it_behaves_like 'invalid'
      end

      context 'roomの参照先がない場合' do
        let(:user_in_room) { build(:user_in_room, :other_room_and_user, room_id: 1) }

        it_behaves_like 'invalid'
      end

      context 'userの参照先がない場合' do
        let(:user_in_room) { build(:user_in_room, :other_room_and_user, user_id: 1) }

        it_behaves_like 'invalid'
      end
    end
  end
end
