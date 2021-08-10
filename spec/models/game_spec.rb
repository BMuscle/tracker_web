# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Validation' do
    subject { game.valid? }

    context '正常系' do
      context 'roomが存在する場合' do
        let(:room) { create(:room, :other_team_room) }
        let(:game) { build(:game, team: room.team, room: room) }

        it { is_expected.to eq(true) }
      end

      context 'roomを指定しない場合' do
        let(:game) { build(:game, :other_team_game, room: nil) }

        it { is_expected.to eq(true) }
      end
    end

    context '異常系' do
      shared_examples_for 'invalid' do
        it { is_expected.to eq(false) }
      end

      context 'teamがない場合' do
        let(:game) { build(:game, team: nil) }

        it_behaves_like 'invalid'
      end

      context 'roomがteamに含まれない場合' do
        let(:other_team) { create(:team, :other_team) }
        let(:room) { create(:room, :other_team_room) }
        let(:game) { build(:game, team: other_team, room: room) }

        it_behaves_like 'invalid'
      end

      context '存在しないroomの場合' do
        let(:team) { create(:team, :other_team) }
        let(:game) { build(:game, team: team, room_id: 1) }

        it 'ActiveRecord::InvalidForeignKeyが発生すること' do
          expect { game.save }.to raise_error(ActiveRecord::InvalidForeignKey)
        end
      end
    end
  end
end
