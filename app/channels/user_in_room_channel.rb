# frozen_string_literal: true

class UserInRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_in_room_#{params[:team_id]}"
  end

  def unsubscribed
    current_user.reload.leave_room
  end
end
