# frozen_string_literal: true

module AgentApi
  class AgentController < ApplicationController
    skip_before_action :authenticate_user
    skip_before_action :check_xhr_header
    before_action :authenticate_agent

    attr_reader :current_user

    private

    def authenticate_agent
      @current_user = Agent.find_by!(guid: params[:agent_guid], token: params[:token]).user
    end
  end
end
