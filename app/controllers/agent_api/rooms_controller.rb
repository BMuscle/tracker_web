# frozen_string_literal: true

module AgentApi
  class RoomsController < AgentApi::AgentController
    before_action :rooms, only: :index
    before_action :room, only: :show

    private

    def rooms
      @rooms = current_user.can_take_teams.includes(rooms: [:users]).find(params[:team_id]).rooms
    end

    def room
      @room = current_user.can_take_teams.includes(:rooms).find(params[:team_id]).rooms.find(params[:id])
    end
  end
end
