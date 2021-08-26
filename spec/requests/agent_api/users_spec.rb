# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AgentApi::Users', type: :request do
  describe 'POST /log_in' do
    subject(:request) do
      post '/agent_api/log_in', params: { user: { email: email, password: password } },
                                headers: { 'X-Requested-With' => 'XMLHttpRequest' }
    end

    let(:user) { create(:user, :confirmed, password: 'password', password_confirmation: 'password') }
    let(:email) { user.email }
    let(:password) { 'password' }

    context '新規にログインする場合' do
      it 'Agentの情報が返ること' do
        request
        expect(parsed_response_body).to eq({ agent: { guid: user.agent.guid, token: user.agent.token } })
      end
    end

    context '既にAgentが存在する場合' do
      let(:agent) { create(:agent, user: user) }

      before do
        agent
        request
      end

      it '既存のAgentが削除されること' do
        expect(Agent.exists?(id: agent.id)).to eq(false)
      end

      it 'Agentの情報が返ること' do
        user.reload
        expect(parsed_response_body).to eq({ agent: { guid: user.agent.guid, token: user.agent.token } })
      end
    end

    context 'ユーザが存在しない場合' do
      let(:email) { 'not_found@example.com' }

      it 'not foundが起きること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'パスワードが間違っている場合' do
      let(:user_id) { user.id }
      let(:password) { 'invalidpassword' }

      it 'not foundが起きること' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
