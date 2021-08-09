# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationLog, use_influx: true do
  let(:user) { create(:user) }
  let(:game) { create(:game, :other_team_game) }

  describe '#write_log' do
    subject(:write_log) { described_class.new(user.id).write_log(game, logs) }

    context 'ログが1件の場合' do
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').utc, latitude: '10.001', longitude: '10.001' }] }

      it 'trueが返ること' do
        expect(write_log).to eq(true)
      end

      it 'ログが1件書き込まれていること' do
        write_log
        expect(described_class.new(user.id).user_location_log(game).size).to eq(1)
      end
    end

    context 'ログが複数件の場合' do
      let(:logs) do
        [
          { time: Time.parse('2020-01-01T00:00:00Z').utc, latitude: '10.001', longitude: '20.001' },
          { time: Time.parse('2020-01-01T00:00:01Z').utc, latitude: '20.001', longitude: '10.001' }
        ]
      end

      it 'trueが返ること' do
        expect(write_log).to eq(true)
      end

      it 'ログが1件書き込まれていること' do
        write_log
        expect(described_class.new(user.id).user_location_log(game).size).to eq(2)
      end
    end

    context 'ログが0件の場合' do
      let(:logs) { [] }

      it 'falseが返ること' do
        expect(write_log).to eq(false)
      end

      it 'ログが書き込まれていないこと' do
        write_log
        expect(described_class.new(user.id).user_location_log(game)).to eq([])
      end
    end
  end

  describe '#user_location_log' do
    def write_log(user, game, logs)
      LocationLog.new(user.id).write_log(game, logs)
    end

    subject(:user_location_log) { described_class.new(user.id).user_location_log(game) }

    context '対象のログが1件の場合' do
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').utc, latitude: '10.001', longitude: '10.001' }] }

      before do
        write_log(user, game, logs)
      end

      it 'ログが1件取得できること' do
        expect(user_location_log.size).to eq(1)
      end
    end

    context '他のユーザのログも存在する場合' do
      let(:other_user) { create(:user) }
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').utc, latitude: '10.001', longitude: '10.001' }] }

      before do
        write_log(user, game, logs)
        write_log(other_user, game, logs)
      end

      it 'ログが1件取得できること' do
        expect(user_location_log.size).to eq(1)
      end
    end

    context '他のゲームのログも存在する場合' do
      let(:other_game) { create(:game, :other_team_game) }
      let(:logs) { [{ time: Time.parse('2020-01-01T00:00:00Z').utc, latitude: '10.001', longitude: '10.001' }] }

      before do
        write_log(user, game, logs)
        write_log(user, other_game, logs)
      end

      it '指定したゲームのログだけが取得できること' do
        expect(user_location_log.size).to eq(1)
      end
    end

    context 'ログが0件の場合' do
      it 'ログが書き込まれていないこと' do
        expect(described_class.new(user.id).user_location_log(game)).to eq([])
      end
    end
  end
end
