# frozen_string_literal: true

module AgentApi
  class TeamsController < AgentApi::AgentController
    def index
      @teams = current_user.can_take_teams
    end

    def show
      @team = current_user.can_take_teams.find(params[:id])
    end
  end
end
