# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /user' do
    subject(:request) { get '/user', headers: { 'X-Requested-With' => 'XMLHttpRequest' } }

    let(:user) { create(:user) }

    context 'ログインしている場合' do
      before do
        log_in user
      end

      it 'ログインしているユーザー情報が取得できること' do
        request
        expect(parsed_response_body).to eq({ email: user.email })
      end
    end

    context 'ログインしていない場合' do
      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
