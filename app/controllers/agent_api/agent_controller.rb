# frozen_string_literal: true

module AgentApi
  class AgentController < ApplicationController
    skip_before_action :authenticate_user
    skip_before_action :check_xhr_header
    before_action :authenticate_agent

    attr_reader :current_user

    private

    def authenticate_agent
      # 機器認証を追加
      @current_user = User.find(params[:user_id])
    end
  end
end
