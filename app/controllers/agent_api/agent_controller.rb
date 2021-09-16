# frozen_string_literal: true

module AgentApi
  class AgentController < ApplicationController
    skip_before_action :authenticate_user
    skip_before_action :check_xhr_header
    before_action :authenticate_agent

    attr_reader :current_user

    private

    def authenticate_agent
      logger.info "Connect AgentGUID=#{request.headers['HTTP_TRACKER_AGENT_GUID']}"
      @current_user = Agent.find_by!(agent_params).user
    end

    def agent_params
      { guid: request.headers['HTTP_TRACKER_AGENT_GUID'], token: request.headers['HTTP_TRACKER_AGENT_TOKEN'] }
    end
  end
end
