# frozen_string_literal: true

module AgentApi
  class UserInRoomsController < AgentApi::AgentController
    def create
      current_user.leave_room
      user_in_room = UserInRoom.new(user: current_user, room: room)
      if user_in_room.save
        Team.broadcast_rooms(params[:team_id], 'participated')
        head :no_content
      else
        head :unprocessable_entity
      end
    end

    private

    def room_params
      params.require(:room).permit(:id)
    end

    def room
      current_user.can_take_teams.find(params[:team_id]).rooms.find(room_params[:id])
    end
  end
end
