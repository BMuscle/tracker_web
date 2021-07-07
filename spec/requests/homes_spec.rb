# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /index' do
    subject(:request) { get homes_path }

    it 'タイトルを含むレスポンスが返ること' do
      request
      expect(response.body).to eq({ 'title' => 'My name is rails' }.to_json)
    end
  end
end
