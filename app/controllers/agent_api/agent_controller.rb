# frozen_string_literal: true

module AgentApi
  class AgentController < ApplicationController
    skip_before_action :authenticate_user
    skip_before_action :check_xhr_header
    before_action :authenticate_agent

    attr_reader :current_user

    private

    def authenticate_agent
      request.headers.sort.map { |k, v| logger.info "#{k}:#{v}" }
      logger.info "Connect AgentGUID=#{request.headers['TRACKER_AGENT_GUID']}"
      @current_user = Agent.find_by!(agent_params).user
    end

    def agent_params
      { guid: request.headers['TRACKER_AGENT_GUID'], token: request.headers['TRACKER_AGENT_TOKEN'] }
    end
  end
end
