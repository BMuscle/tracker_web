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

  describe 'POST /sign_up' do
    subject(:request) do
      post '/sign_up', params: { user: user_params }, headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user_params) { { email: email, password: password, password_confirmation: password_confirmation } }
    let(:email) { 'test@example.com' }
    let(:password) { 'password' }
    let(:password_confirmation) { password }

    it '204が返ること' do
      request
      expect(response).to have_http_status(:no_content)
    end

    context '不正なパラメータの場合' do
      context 'Eメールが不正' do
        let(:email) { '@com' }

        it '400が返ることt' do
          request
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'パスワードが不正' do
        let(:password) { 'short' }

        it '400が返ることt' do
          request
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'パスワードが一致しない' do
        let(:password_confirmation) { 'aaaaaaaa' }

        it '400が返ること' do
          request
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
