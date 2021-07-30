# frozen_string_literal: true

class UserInRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_in_room_#{params[:team_id]}"
    p '=============='
    p "subscribed #{params[:team_id]}, #{current_user.email}"
    p '=============='
  end

  def unsubscribed
    p '=============='
    p "unsubscribed #{current_user.email}"
    p '=============='
  end
end
