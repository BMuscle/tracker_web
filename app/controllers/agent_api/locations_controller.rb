# frozen_string_literal: true

module AgentApi
  class LocationsController < AgentApi::AgentController
    before_action :game

    def create
      LocationLog.new(current_user.id).write_logs(@game, location_logs[:logs]) if location_logs.present?

      head :no_content
    end

    private

    def location_logs
      params.require(:location).permit(logs: %i[time latitude longitude])
    end

    def game
      @game = current_user.can_take_teams.find(params[:team_id]).games.find(params[:game_id])
    end
  end
end
