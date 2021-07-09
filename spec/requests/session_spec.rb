# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'POST /log_in' do
    subject(:request) { post log_in_path, params: params, headers: { 'X-Requested-With' => 'XMLHttpRequest' } }

    let(:password) { 'password' }
    let(:user) { create(:user, password: password, password_confirmation: password) }
    let(:params) { { user: { email: user.email, password: password } } }

    before do
      user
    end

    it '204が返ること' do
      request
      expect(response).to have_http_status(:no_content)
    end

    context '存在しないユーザを指定した場合' do
      let(:params) { { user: { email: 'not@example.com', password: password } } }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end

    context '存在するユーザの間違ったパスワードを指定した場合' do
      let(:params) { { user: { email: user.email, password: 'not_password' } } }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end

    context '空のパラメータで送信した場合' do
      let(:params) { { user: { email: '', password: '' } } }

      it '404が返ること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /log_out' do
    subject(:request) { post log_out_path, headers: { 'X-Requested-With' => 'XMLHttpRequest' } }

    let(:password) { 'password' }
    let(:user) { create(:user, password: password, password_confirmation: password) }

    context 'ログインしている場合' do
      before do
        log_in(user)
      end

      it '204が返ること' do
        request
        expect(response).to have_http_status(:no_content)
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
